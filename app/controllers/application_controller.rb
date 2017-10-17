class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  layout :layout

  before_action :store_user_location, if: :storable_location?
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to( { controller: 'home', action: 'not_authorized' } )
  end


  private
    # Its important that the location is NOT stored if:
    # - The request method is not GET (non idempotent)
    # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an infinite redirect loop.
    # - The request is an Ajax request as this can lead to very unexpected behaviour.
    def storable_location?
      request.get? && !devise_controller? && !request.xhr?
    end

    def store_user_location
      store_location_for(:user, request.fullpath)
    end

    def layout
      return 'devise' if devise_controller?
      return 'application'
    end
end
