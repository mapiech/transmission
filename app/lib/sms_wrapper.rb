require 'mprofi_api_client'

class SmsWrapper

  API_TOKEN = ENV['SMS_TOKEN']

  class << self

    def send_message(number, message)
      connector = MprofiApiClient::Connector.new(API_TOKEN)
      begin
        connector.add_message(number, message,)
        connector.send
      rescue MprofiAuthError
        Airbrake.notify("MprofiAuthError")
        false
      rescue MprofiConnectionError
        Airbrake.notify("MprofiConnectionError")
        false
      end
    end

  end

end