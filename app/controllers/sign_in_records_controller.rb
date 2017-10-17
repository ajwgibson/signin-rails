class SignInRecordsController < ApplicationController

  load_and_authorize_resource


  def index
    @title = 'Sign in records'
  end


  def show
    @title = 'Sign in record details'
  end

end
