class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable,
         :trackable,
         :validatable,
         :lockable,
         :timeoutable


  validates :first_name, presence: true
  validates :last_name,  presence: true


  def name
    "#{first_name} #{last_name}".strip
  end

end
