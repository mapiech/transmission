module AsteriskWrapper

  module Ari

    @@ari = nil

    def ari
      @@ari ||= ::Ari::Client.new({
                                      url: 'http://192.168.0.15:8088/ari',
                                      api_key: 'asterisk:asterisk'
                                  })
    end

  end

end