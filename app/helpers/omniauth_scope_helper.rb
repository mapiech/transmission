module OmniauthScopeHelper

  def omniauth_url(scope_resource, omniauth_params = {})
    omniauth_params[:scope] = omniauth_scope(scope_resource)
    "/auth/google_oauth2?#{omniauth_params.to_query}"
  end

  def omniauth_scope(scope_resource)
    case scope_resource
      when :user
        'userinfo.email,userinfo.profile'
      when :congregation
        'http://gdata.youtube.com,userinfo.email,userinfo.profile'
    end
  end

end