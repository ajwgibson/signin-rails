class SignInRecord < ApplicationRecord

  include HasSortableName


  validates :first_name,   presence: true
  validates :last_name,    presence: true
  validates :room,         presence: true
  validates :label,        presence: true
  validates :sign_in_time, presence: true

end
