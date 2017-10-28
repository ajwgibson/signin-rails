require 'csv'

class ImportSigninRecordsJob < ApplicationJob

  queue_as :default

  def perform(import_id)

    record = SignInRecordImport.find(import_id)

    record.update({
      status: :running,
      success_count: 0,
      error_count: 0
    })

    CSV::HeaderConverters[:sign_in] = lambda { |s|
      s = 'id'               if s == 'Id'
      s = 'first_name'       if s == 'First'
      s = 'last_name'        if s == 'Last'
      s = 'room'             if s == 'Room'
      s = 'sign_in_time'     if s == 'SignedInAt'
      s = 'label'            if s == 'Label'
      s = 'newcomer'         if s == 'IsNewcomer'
      s = 'update_required'  if s == 'UpdateRequired'
      s = 'medical_flag'     if s == 'MedicalFlag'
      s
    }

    errors  = []

    CSV.foreach(record.upload_file.path,
          headers: true, header_converters: :sign_in, encoding: 'bom|utf-8') do |row|

      if (!row['sign_in_time'].blank?)

        original = row.fields

        row['sign_in_time'] = parse_sign_in_time row['sign_in_time']
        row['newcomer']     = row['newcomer'] == 'True'

        begin
          r = SignInRecord
              .where(row.to_hash.except('update_required', 'id', 'medical_flag'))
              .first_or_initialize(row.to_hash.except('update_required', 'id', 'medical_flag'))
          if r.new_record?
            r.save!
            record.update({success_count: record.success_count + 1})
          end
        rescue
          errors << original
          record.update({error_count: record.error_count + 1})
        end

      end

    end

    if errors.count > 0
      CSV.generate() do |csv|
        csv << ['Id', 'First', 'Last', 'Room', 'SignedInAt', 'Label', 'IsNewcomer', 'UpdateRequired']
        errors.each { |row| csv << row }
        file = StringIO.new(csv.string)
        record.error_file = file
        record.error_file.instance_write(:content_type, 'text/csv')
        record.error_file.instance_write(:file_name, 'errors.csv')
      end
    end

    record.complete!

  end


  private

    def parse_sign_in_time(sign_in_time)
      if !sign_in_time.blank?
        begin
          return DateTime.strptime(sign_in_time, '%Y-%m-%d %H:%M:%S %Z')
        rescue ArgumentError
        end
      end
      return nil
    end

end
