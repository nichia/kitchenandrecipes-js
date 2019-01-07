class RegistrationsController < Devise::RegistrationsController

  protected

  # Overwrite update_resource for users to update their profile (excluding password, email and avatar) without giving their current password
  def update_resource(resource, params)
    if ["facebook", "github", "google_oauth2"].include? current_user.provider
      params.delete("email")
      params.delete("avatar")
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

end
