module AsteriskWrapper

  module PhoneNumberParser

    def parse_caller_id(raw_caller)
      raw_caller[0..8]
    end

    def parse_exten_id(raw_caller)
      raw_caller[9..17]
    end

  end

end