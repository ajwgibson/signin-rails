require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:default_user)).to be_valid
  end


  # VALIDATION

  describe 'A user' do
    it "is not valid without a first name" do
      expect(FactoryGirl.build(:default_user, first_name: nil)).not_to be_valid
    end
    it "is not valid without a last name" do
      expect(FactoryGirl.build(:default_user, last_name: nil)).not_to be_valid
    end
  end


  # METHODS

  describe '#name' do
    it "is 'John Smith' when first_name is 'John' and last_name is 'Smith'" do
      expect(FactoryGirl.build(:default_user, first_name: 'John', last_name: 'Smith').name).to eq('John Smith')
    end
    it "is 'John' when first_name is 'John' and last_name is nil" do
      expect(FactoryGirl.build(:default_user, first_name: 'John', last_name: nil).name).to eq('John')
    end
    it "is 'Smith' when first_name is nil and last_name is 'Smith'" do
      expect(FactoryGirl.build(:default_user, first_name: nil, last_name: 'Smith').name).to eq('Smith')
    end
  end

end
