class HomeController < ApplicationController

  def index
    @title = 'Dashboard'

    @dates = SignInRecord.unique_dates(10)

    if params.has_key?(:date)
      begin
        @date = Date.parse(params[:date])
      rescue
      end
    else
      @date = @dates[0] if @dates
    end

    @date = Date.today unless @date

    @child_count     = SignInRecord.child_count(@date)
    @newcomer_count  = SignInRecord.newcomer_count(@date)
    @room_counts     = SignInRecord.room_counts(@date)
    @historic_counts = SignInRecord.historic_counts
  end


  def not_authorized
    render "errors/403"
  end

end
