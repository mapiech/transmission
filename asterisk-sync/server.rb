require 'ruby_ami'
require 'net/http'
require "#{__dir__}/event_filter"

def handle_event(event)
  event_filter = EventFilter.new(event)

  begin
    if event_filter.transfer?
      uri = URI('http://localhost:3000/asterisk/sync')
      Net::HTTP.post_form(uri, event: event.name, data: event.headers)
    end
  rescue Exception => e
    puts e
  end
end

stream = RubyAMI::Stream.supervise_as :ami_connection, '192.168.0.15', 5038, 'admin', 'Zdrojowa13',
                             ->(e, stream) { handle_event e },
                             Logger.new(STDOUT), 10

Celluloid::Actor.join(stream)

loop do
  sleep 5
end
