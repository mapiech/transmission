module AsteriskWrapper
  class ChannelDecorator < Draper::Decorator

    def users_count_text
      case object.users_count
        when 1 then '1 osoba słucha'
        when 2..4 then "#{object.users_count} osoby słuchają"
        else "#{object.users_count} osób słucha"
      end
    end

  end
end
