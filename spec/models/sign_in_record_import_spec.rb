require 'rails_helper'

RSpec.describe SignInRecordImport, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:pending_sign_in_record_import)).to be_valid
  end

end
