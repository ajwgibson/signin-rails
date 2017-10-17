class Ability

  include CanCan::Ability

  def initialize(user)
    if !user.nil?
      can :manage, :all if user.admin
    end
  end

end
