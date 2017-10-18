FactoryGirl.define do

  factory :sign_in_record_import do
    success_count   nil
    error_count     nil
    upload_file     nil
    error_file      nil
  end

  factory :pending_sign_in_record_import, parent: :sign_in_record_import do
    status          :pending
    success_count   nil
    error_count     nil
    upload_file     { File.new("#{Rails.root}/spec/support/fixtures/upload.csv") }
    error_file      nil
  end

  factory :running_sign_in_record_import, parent: :pending_sign_in_record_import do
    status          :running
  end

  factory :successful_sign_in_record_import, parent: :pending_sign_in_record_import do
    status          :complete
    success_count   100
    error_count     0
  end

  factory :errored_sign_in_record_import, parent: :pending_sign_in_record_import do
    status          :complete
    success_count   99
    error_count     1
    error_file      { File.new("#{Rails.root}/spec/support/fixtures/errors.csv") }
  end


end
