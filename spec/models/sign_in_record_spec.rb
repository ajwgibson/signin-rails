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


  # Scopes

  describe 'scope:with_first_name' do
    it 'includes records whose first name matches the value' do
      a = FactoryGirl.create(:default_sign_in_record, :first_name => 'a')
      b = FactoryGirl.create(:default_sign_in_record, :first_name => 'ba')
      c = FactoryGirl.create(:default_sign_in_record, :first_name => 'bac')
      d = FactoryGirl.create(:default_sign_in_record, :first_name => 'z')
      filtered = SignInRecord.with_first_name('a')
      expect(filtered).to     include(a, b, c)
      expect(filtered).not_to include(d)
    end
    it 'ignores case' do
      a = FactoryGirl.create(:default_sign_in_record, :first_name => 'aAa')
      filtered = SignInRecord.with_first_name('aaa')
      expect(filtered).to include(a)
    end
  end

  describe 'scope:with_last_name' do
    it 'includes records whose last name matches the value' do
      a = FactoryGirl.create(:default_sign_in_record, :last_name => 'a')
      b = FactoryGirl.create(:default_sign_in_record, :last_name => 'ba')
      c = FactoryGirl.create(:default_sign_in_record, :last_name => 'bac')
      d = FactoryGirl.create(:default_sign_in_record, :last_name => 'z')
      filtered = SignInRecord.with_last_name('a')
      expect(filtered).to     include(a, b, c)
      expect(filtered).not_to include(d)
    end
    it 'ignores case' do
      a = FactoryGirl.create(:default_sign_in_record, :last_name => 'aAa')
      filtered = SignInRecord.with_last_name('aaa')
      expect(filtered).to include(a)
    end
  end

  describe 'scope:in_room' do
    it 'includes records whose room matches the value' do
      a = FactoryGirl.create(:default_sign_in_record, :room => 'a')
      b = FactoryGirl.create(:default_sign_in_record, :room => 'b')
      filtered = SignInRecord.in_room('a')
      expect(filtered).to     include(a)
      expect(filtered).not_to include(b)
    end
  end

  describe 'scope:is_newcomer' do
    it 'includes records whose newcomer flag matches the value' do
      a = FactoryGirl.create(:default_sign_in_record, :newcomer => true)
      b = FactoryGirl.create(:default_sign_in_record, :newcomer => false)
      filtered = SignInRecord.is_newcomer(true)
      expect(filtered).to     include(a)
      expect(filtered).not_to include(b)
    end
  end

  describe 'scope:for_today' do
    it 'includes records that fall on the current date' do
      a  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 1.days.ago)
      b  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 0.days.ago)
      c  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 1.days.from_now)
      filtered = SignInRecord.for_today()
      expect(filtered).to     include(b)
      expect(filtered).not_to include(a, c)
    end
  end

  describe 'scope:on_or_after' do
    it 'includes records that fall on or after the date provided' do
      a  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 2.days.ago)
      b  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 3.days.ago)
      c  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 1.days.ago)
      filtered = SignInRecord.on_or_after(2.days.ago)
      expect(filtered).to     include(a, c)
      expect(filtered).not_to include(b)
    end
  end

  describe 'scope:on_or_before' do
    it 'includes records that fall on or before the date provided' do
      a  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 2.days.ago)
      b  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 3.days.ago)
      c  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 1.days.ago)
      filtered = SignInRecord.on_or_before(2.days.ago)
      expect(filtered).to     include(a, b)
      expect(filtered).not_to include(c)
    end
  end

  describe 'scope:for_date' do
    it 'includes records that fall on the date provided' do
      a  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 2.days.ago)
      b  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 3.days.ago)
      c  = FactoryGirl.create(:default_sign_in_record, sign_in_time: 1.days.ago)
      filtered = SignInRecord.for_date(3.days.ago)
      expect(filtered).to     include(b)
      expect(filtered).not_to include(a)
      expect(filtered).not_to include(c)
    end
  end


  # METHODS

  describe 'self.room_list' do
    it "returns a list of unique room names ordered alphabetically" do
      FactoryGirl.create(:default_sign_in_record, room: 'b')
      FactoryGirl.create(:default_sign_in_record, room: 'a')
      FactoryGirl.create(:default_sign_in_record, room: 'a')
      FactoryGirl.create(:default_sign_in_record, room: 'c')
      rooms = SignInRecord.room_list
      expect(rooms).to eq(['a','b','c'])
    end
  end


  describe 'self.unique_dates' do
    it "returns a unique list of actual sign in dates" do
      FactoryGirl.create(:default_sign_in_record, sign_in_time: 2.days.ago)
      FactoryGirl.create(:default_sign_in_record, sign_in_time: 2.days.ago)
      FactoryGirl.create(:default_sign_in_record, sign_in_time: 3.days.ago)
      FactoryGirl.create(:default_sign_in_record, sign_in_time: 4.days.ago)
      FactoryGirl.create(:default_sign_in_record, sign_in_time: 4.days.ago)
      dates = SignInRecord.unique_dates 100
      expect(dates).to eq([2.days.ago.to_date, 3.days.ago.to_date, 4.days.ago.to_date])
    end
    it "only returns the most recent 'n' dates" do
      FactoryGirl.create(:default_sign_in_record, sign_in_time: 2.days.ago)
      FactoryGirl.create(:default_sign_in_record, sign_in_time: 3.days.ago)
      FactoryGirl.create(:default_sign_in_record, sign_in_time: 4.days.ago)
      dates = SignInRecord.unique_dates 2
      expect(dates).to eq([2.days.ago.to_date, 3.days.ago.to_date])
    end
  end


  describe 'self.child_count' do
    it "returns a count of children signed in on the given date" do
      the_date = Date.new(2017,1,2)
      my_double = double
      expect(SignInRecord).to receive(:for_date).with(the_date).and_return(my_double)
      expect(my_double).to receive(:count).and_return(10)
      expect(SignInRecord.child_count(the_date)).to eq(10)
    end
  end


  describe 'self.child_count' do
    it "returns a count of children signed in on the given date" do
      the_date = Date.new(2017,1,2)
      my_double = double
      expect(SignInRecord).to receive(:for_date).with(the_date).and_return(my_double)
      expect(my_double).to receive(:is_newcomer).with(true).and_return(my_double)
      expect(my_double).to receive(:count).and_return(10)
      expect(SignInRecord.newcomer_count(the_date)).to eq(10)
    end
  end


  describe 'self.room_counts' do
    it "returns a hash of room counts for the specified date" do
      my_double = double
      expect(my_double).to receive(:group).with(:room).and_return(my_double)
      expect(my_double).to receive(:count).with(:room).and_return({A:1,B:2})
      expect(SignInRecord).to receive(:for_date).with(Date.new(2017,1,2)).and_return(my_double)
      result = SignInRecord.room_counts Date.new(2017,1,2)
      expect(result).to eq({A:1,B:2})
    end
  end


  describe 'self.historic_counts' do
    it "returns a hash of counts by date" do
      my_double = double
      expect(SignInRecord).to receive(:select).with('date(sign_in_time)').and_return(my_double)
      expect(my_double).to receive(:order).with('date(sign_in_time)').and_return(my_double)
      expect(my_double).to receive(:group).with('date(sign_in_time)').and_return(my_double)
      expect(my_double).to receive(:count).with('date(sign_in_time)').and_return({A:1,B:2})
      result = SignInRecord.historic_counts
      expect(result).to eq({A:1,B:2})
    end
  end


end
