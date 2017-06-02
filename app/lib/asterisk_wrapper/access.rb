module AsteriskWrapper

  class Access

    include PhoneNumberParser

    DENIED_TEXT = 'denied'

    attr_accessor :caller_id, :exten_id, :internal_phone_number_for_caller

    def initialize(raw_caller)
      self.caller_id = parse_caller_id(raw_caller)
      self.exten_id =  parse_exten_id(raw_caller)
      self.internal_phone_number_for_caller = DENIED_TEXT
    end

    class << self
      def internal_phone_number_for_caller(raw_caller)
        new(raw_caller).find_internal_phone_number_for_caller
      end
    end

    # empty means no access
    # return internal exten to confbrige

    def find_internal_phone_number_for_caller
      begin

        phone = Phone.where(phone_number: caller_id).first
        if phone

          user = phone.user

          if user.allow_join_to_any

            phone_transmission = PhoneTransmission.where(sip_phone_number: exten_id).first
            if phone_transmission
              self.internal_phone_number_for_caller = phone_transmission.internal_phone_number
            end

          else

            phone_transmission = user.congregation.phone_transmission
            if phone_transmission.sip_phone_number == exten_id
              self.internal_phone_number_for_caller = phone_transmission.internal_phone_number
            end

          end
        end
      rescue
        self.internal_phone_number_for_caller = DENIED_TEXT
      end

      internal_phone_number_for_caller

    end

  end

end
