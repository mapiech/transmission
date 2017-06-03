Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '579552024252-91bcgt6u7sg8g3bj4mdmrme8ofins3mv.apps.googleusercontent.com', 'Ekqbf5ybf4qfUxsTPxfQ-c40',
           { scope: 'http://gdata.youtube.com,userinfo.email,userinfo.profile,plus.me', approval_prompt: ''}
end


