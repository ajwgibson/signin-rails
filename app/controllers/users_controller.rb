class UsersController < ApplicationController

  load_and_authorize_resource


  def index
    @title = 'Users'
    @users = User.order(:first_name, :last_name)
  end


  def show
    @title = 'User details'
  end


  def new
    @title       = 'Add a user'
    @user        = User.new
    @cancel_path = users_path
    render :edit
  end


  def create
    @user = User.new user_params
    if @user.save
      redirect_to( { action: 'index' }, notice: 'User was created successfully' )
    else
      @title       = 'Add a user'
      @cancel_path = users_path
      render :edit
    end
  end


  def edit
    @title       = 'Edit user details'
    @cancel_path = user_path(@user)
  end


  def update
    if @user.update_without_password user_params
      redirect_to user_path(@user), notice: 'User was updated successfully'
    else
      @title       = 'Edit user details'
      @cancel_path = user_path(@user)
      render :edit
    end
  end


  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was deleted'
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    # Parameter white list
    def user_params
      params
        .require(:user)
        .permit(
          :email,
          :first_name,
          :last_name,
          :password,
          :password_confirmation,
          :admin,
        )
    end

end
