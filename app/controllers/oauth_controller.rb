class OauthController < ApplicationController

  def callback
    begin
      send current_resource
    rescue
      redirect_to auth_failure_path(l: current_layout)
    end
  end

  def failure
    render layout: (params[:l].present? ? params[:l] : 'public')
  end

  protected

  def user
    email = request.env['omniauth.auth'].info.email
    user = User.where(email: email).first
    if user
      sign_in(:user, user)
      redirect_to public_root_path
    else
      raise
    end
  end

  def congregation
    if request.env['omniauth.auth'].info.email == ENV['GOOGLE_DEFAULT_EMAIL'] && request.env['omniauth.auth'].credentials.refresh_token.present?
      VideoTransmission.update_all(refresh_token: request.env['omniauth.auth'].credentials.refresh_token)
    end
    redirect_to root_path and return
  end

  def current_resource
    @current_resource ||= (current_congregation and request.env['omniauth.params']['scope'].include?('youtube')) ?
      :congregation : :user
  end

  def current_layout
    current_resource == :user ? 'public' : 'application'
  end



end
