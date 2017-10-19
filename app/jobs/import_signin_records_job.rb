require 'csv'

class ImportSigninRecordsJob < ApplicationJob

  queue_as :default

  def perform(import_id)

    record = SignInRecordImport.find(import_id)

    record.running!

    CSV::HeaderConverters[:sign_in] = lambda { |s|
      s = 'label'            if s == 'Id'
      s = 'first_name'       if s == 'First'
      s = 'last_name'        if s == 'Last'
      s = 'room'             if s == 'Room'
      s = 'sign_in_time'     if s == 'SignedInAt'
      s = 'newcomer'         if s == 'IsNewcomer'
      s = 'update_required'  if s == 'UpdateRequired'
      s
    }

    imports = 0
    errors  = []

    CSV.foreach(record.upload_file.path,
          headers: true, header_converters: :sign_in, encoding: 'bom|utf-8') do |row|

      if (!row['sign_in_time'].blank?)

        original = row.fields

        row['sign_in_time'] = parse_sign_in_time row['sign_in_time']
        row['newcomer']     = row['newcomer'] == 'True'

        begin
          r = SignInRecord
              .where(row.to_hash.except('update_required'))
              .first_or_initialize(row.to_hash.except('update_required'))
          if r.new_record?
            r.save!
            imports = imports + 1
          end
        rescue
          errors << original
        end

      end

    end

    if errors.count > 0
      CSV.generate() do |csv|
        csv << ['Id', 'First', 'Last', 'Room', 'SignedInAt', 'IsNewcomer', 'UpdateRequired']
        errors.each { |row| csv << row }
        file = StringIO.new(csv.string)
        record.error_file = file
        record.error_file.instance_write(:content_type, 'text/csv')
        record.error_file.instance_write(:file_name, 'errors.csv')
      end
    end

    record.update({
      success_count: imports,
      error_count:   errors.count,
      status:        :complete
    })

  end


  private

    def parse_sign_in_time(sign_in_time)
      if !sign_in_time.blank?
        begin
          return DateTime.strptime(sign_in_time, '%d/%m/%Y %H:%M:%S')
        rescue ArgumentError
        end
      end
      return nil
    end

end
