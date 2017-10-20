class SignInRecordsController < ApplicationController

  load_and_authorize_resource


  def index
    @title = 'Sign in records'
    @filter = get_filter
    @sign_in_records = SignInRecord.filter(@filter).order(sign_in_time: :desc)
    @sign_in_records = @sign_in_records.page(params[:page])
    set_filter @filter
    @rooms = SignInRecord.room_list
  end


  def clear_filter
    set_filter nil
    redirect_to action: :index
  end


  def show
    @title = 'Sign in record details'
  end



private

  def get_filter
    filter =
      params
        .permit(
          :order_by,
          :with_first_name,
          :with_last_name,
          :in_room,
          :is_newcomer,
          :for_today,
          :on_or_after,
          :on_or_before,
          :for_date,
        ).to_h
    filter = session[:filter_sign_in_records].symbolize_keys! if filter.empty? && session.key?(:filter_sign_in_records)
    filter = { :order_by => 'sign_in_time desc' } if filter.empty?
    filter.delete_if { |key, value| value.blank? }
    filter[:on_or_after]  = DateTime.parse(filter[:on_or_after])  if filter.key?(:on_or_after)
    filter[:on_or_before] = DateTime.parse(filter[:on_or_before]) if filter.key?(:on_or_before)
    filter[:for_date]     = DateTime.parse(filter[:for_date])     if filter.key?(:for_date)
    filter
  end


  def set_filter(filter)
    session[:filter_sign_in_records] = filter unless filter.nil?
    session.delete(:filter_sign_in_records) if filter.nil?
  end

end
