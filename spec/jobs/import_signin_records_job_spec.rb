require 'rails_helper'

RSpec.describe ImportSigninRecordsJob, type: :job do

  context "for a successful import" do
    let(:import) { FactoryGirl.create(
      :pending_sign_in_record_import,
      upload_file: File.new("#{Rails.root}/spec/support/fixtures/upload.csv"))
    }
    before(:each) do
      ImportSigninRecordsJob.perform_now(import.id)
      import.reload
    end
    it 'imports the individual sign in records from the upload file' do
      expect(SignInRecord.count).to eq(1)
    end
    it 'updates the status of the import record' do
      expect(import.complete?).to be_truthy
    end
    it 'records the number of records imported' do
      expect(import.success_count).to eq(1)
    end
    it 'records the number of errors as zero' do
      expect(import.error_count).to eq(0)
    end
    it 'does not create an error file' do
      expect(import.error_file.exists?).to be_falsey
    end
  end

  context "for an import with duplicate records" do
    let(:import) { FactoryGirl.create(
      :pending_sign_in_record_import,
      upload_file: File.new("#{Rails.root}/spec/support/fixtures/duplicate.csv"))
    }
    before(:each) do
      ImportSigninRecordsJob.perform_now(import.id)
      import.reload
    end
    it 'ignores duplicates' do
      expect(SignInRecord.count).to eq(1)
      expect(import.success_count).to eq(1)
    end
    it 'does not treat duplicates as errors' do
      expect(import.error_count).to eq(0)
    end
  end

  context "for an import with no sign in records" do
    let(:import) { FactoryGirl.create(
      :pending_sign_in_record_import,
      upload_file: File.new("#{Rails.root}/spec/support/fixtures/not_signed_in.csv"))
    }
    before(:each) do
      ImportSigninRecordsJob.perform_now(import.id)
      import.reload
    end
    it 'records zero imports' do
      expect(SignInRecord.count).to eq(0)
      expect(import.success_count).to eq(0)
    end
  end

  context "for an import with invalid records" do
    let(:import) { FactoryGirl.create(
      :pending_sign_in_record_import,
      upload_file: File.new("#{Rails.root}/spec/support/fixtures/errors.csv"))
    }
    before(:each) do
      ImportSigninRecordsJob.perform_now(import.id)
      import.reload
    end
    it 'records zero imports' do
      expect(SignInRecord.count).to eq(0)
      expect(import.success_count).to eq(0)
    end
    it "records the error count" do
      expect(import.error_count).to eq(2)
    end
    it "stores the error records in an output file" do
      expect(import.error_file.exists?).to be_truthy
    end
  end

end
