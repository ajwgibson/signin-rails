class HomeController < ApplicationController

  def index
    @title = 'Dashboard'
  end


  def not_authorized
    render "errors/403"
  end

end
