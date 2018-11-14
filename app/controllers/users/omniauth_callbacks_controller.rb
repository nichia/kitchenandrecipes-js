class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # facebook callback
  def facebook
    callback_from(:facebook)
  end

  # github callback
  def github
    callback_from(:github)
  end

	# google callback
	def google_oauth2
		callback_from(:google_oauth2)
	end

  def failure
    # flash[:error] = 'There was a problem signing you in. Please register or try signing in later.'
    set_flash_message! :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    redirect_to root_path
  end

	private

	def callback_from(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    binding.pry
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
    else
      flash[:error] = "There was a problem signing you in through #{provider}."
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
