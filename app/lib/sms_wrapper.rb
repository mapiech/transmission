require 'serwersms'

class SmsWrapper

  class << self

    def send_message(number, message)
      api = Serwersms.new('sala.wloclawek','48kdieQP(&#LDaies1')
      api.messages.sendSms(number, message, 'INFORMACJA', {})
    end

  end

end