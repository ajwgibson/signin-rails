class SignInRecord < ApplicationRecord

  include Filterable
  include HasSortableName


  validates :first_name,   presence: true
  validates :last_name,    presence: true
  validates :room,         presence: true
  validates :label,        presence: true
  validates :sign_in_time, presence: true


  scope :with_first_name, ->(value) { where("lower(first_name) like lower(?)", "%#{value}%") }
  scope :with_last_name,  ->(value) { where("lower(last_name)  like lower(?)", "%#{value}%") }
  scope :in_room,         ->(value) { where room: value }
  scope :is_newcomer,     ->(value) { where newcomer: value }
  scope :for_today,       ->(value=true) { where("date(sign_in_time) = ?", Date.today) }
  scope :on_or_after,     ->(value) { where("sign_in_time >= ?",  value.beginning_of_day) }
  scope :on_or_before,    ->(value) { where("sign_in_time < ?",   value.end_of_day) }


  def self.room_list
    SignInRecord.distinct.order(:room).pluck(:room)
  end

end
