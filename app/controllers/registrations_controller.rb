class RegistrationsController < Devise::RegistrationsController
  protected
    def after_update_path_for(resource)
      root_url
    end
end
