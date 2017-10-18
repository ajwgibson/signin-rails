class SignInRecordImportsController < ApplicationController

  load_and_authorize_resource


  def index
    @title = 'Sign in record imports'
    @sign_in_records = SignInRecordImport.order(created_at: :desc)
    @sign_in_records = @sign_in_records.page(params[:page])
  end


  def show
    @title = 'Sign in record import details'
  end



private
  

end
