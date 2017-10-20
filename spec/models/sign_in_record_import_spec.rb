require 'rails_helper'

RSpec.describe SignInRecordImport, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:pending_sign_in_record_import)).to be_valid
  end


  # METHODS

  describe "#started_at" do
    it "returns the record created_at value" do
      record = FactoryGirl.create(:pending_sign_in_record_import)
      expect(record.started_at).to eq(record.created_at)
    end
  end


  describe "#finished_at" do
    context "when the job has not completed" do
      it "returns nil" do
        record = FactoryGirl.create(:pending_sign_in_record_import)
        expect(record.finished_at).to be_nil
      end
    end
    context "when the job has not completed" do
      it "returns the updated_at value" do
        record = FactoryGirl.create(:successful_sign_in_record_import)
        expect(record.finished_at).to eq(record.updated_at)
      end
    end
  end

end
