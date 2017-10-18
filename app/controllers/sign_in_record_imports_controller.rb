class SignInRecordImportsController < ApplicationController

  load_and_authorize_resource


  def index
    @title = 'Sign in record imports'
    @sign_in_record_imports = SignInRecordImport.order(created_at: :desc)
    @sign_in_record_imports = @sign_in_record_imports.page(params[:page])
  end


  def show
    @title = 'Sign in record import details'
  end


  def new
    @title = 'Import sign in records'
    @cancel_path = sign_in_record_imports_path
  end


  def create
    @sign_in_record_import = SignInRecordImport.new({ upload_file: params[:upload_file] })
    if @sign_in_record_import.save
      redirect_to( { action: 'index' }, notice: 'Import created successfully' )
    else
      @title       = 'Import sign in records'
      @cancel_path = sign_in_record_imports_path
      render :new
    end
  end


end
