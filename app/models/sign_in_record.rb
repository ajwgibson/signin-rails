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
  scope :for_today,       ->(value=true) { for_date(Date.today) }
  scope :on_or_after,     ->(value) { where("sign_in_time >= ?", value.beginning_of_day) }
  scope :on_or_before,    ->(value) { where("sign_in_time < ?",  value.end_of_day) }
  scope :for_date,        ->(value) { where("date(sign_in_time) = ?", value) }


  def self.room_list
    SignInRecord.distinct.order(:room).pluck(:room)
  end


  def self.unique_dates(limit)
      SignInRecord
        .distinct
        .order('date(sign_in_time) desc')
        .pluck('date(sign_in_time)')
        .take(limit)
        .map { |d| d.to_date }
  end


  def self.child_count(date)
    SignInRecord.for_date(date).count
  end


  def self.newcomer_count(date)
    SignInRecord.for_date(date).is_newcomer(true).count
  end


  def self.room_counts(date)
    SignInRecord.for_date(date).group(:room).count(:room)
  end


  def self.historic_counts
    SignInRecord
      .select('date(sign_in_time)')
      .order('date(sign_in_time)')
      .group('date(sign_in_time)')
      .count('date(sign_in_time)')
  end

end
