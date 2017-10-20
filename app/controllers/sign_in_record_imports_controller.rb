class SignInRecordImportsController < ApplicationController

  load_and_authorize_resource


  def index
    @title = 'Import records'
    @sign_in_record_imports = SignInRecordImport.order(created_at: :desc)
    @sign_in_record_imports = @sign_in_record_imports.page(params[:page])
  end


  def show
    @title = 'Import details'
  end


  def new
    @title = 'Import data'
    @cancel_path = sign_in_record_imports_path
  end


  def create
    @sign_in_record_import = SignInRecordImport.new({ upload_file: params[:upload_file] })
    if @sign_in_record_import.save
      ImportSigninRecordsJob.perform_later @sign_in_record_import.id
      redirect_to( { action: 'index' }, notice: 'Import created successfully' )
    else
      @title       = 'Import data'
      @cancel_path = sign_in_record_imports_path
      render :new
    end
  end


end
