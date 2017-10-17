require 'rails_helper'

RSpec.describe SignInRecord, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:default_sign_in_record)).to be_valid
  end


  # VALIDATION

  describe 'A sign in record' do
    it "is not valid without a first name" do
      expect(FactoryGirl.build(:default_sign_in_record, first_name: nil)).not_to be_valid
    end
    it "is not valid without a last name" do
      expect(FactoryGirl.build(:default_sign_in_record, last_name: nil)).not_to be_valid
    end
    it "is not valid without a room" do
      expect(FactoryGirl.build(:default_sign_in_record, room: nil)).not_to be_valid
    end
    it "is not valid without a sign in time" do
      expect(FactoryGirl.build(:default_sign_in_record, sign_in_time: nil)).not_to be_valid
    end
    it "is not valid without a label" do
      expect(FactoryGirl.build(:default_sign_in_record, label: nil)).not_to be_valid
    end
  end
  

end
