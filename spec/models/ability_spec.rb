require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do

  subject(:ability) { Ability.new(user) }

  let(:user)        { nil }

  context "default users" do
    let(:user) { FactoryGirl.build(:default_user) }
    it { is_expected.to not_have_abilities([:manage], User) }
  end

  context "administrators" do
    let(:user)    { FactoryGirl.build(:administrator) }
    it { is_expected.to have_abilities([:manage], :all) }
  end

end
