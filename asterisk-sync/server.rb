require 'ruby_ami'
require 'net/http'
require 'yaml'
require "#{__dir__}/event_filter"


configuration = YAML.load(File.read(File.join(__dir__, '..', 'config', 'asterisk.yml')))
@ami_callback_url = configuration['ami_callback_url']

def handle_event(event)
  event_filter = EventFilter.new(event)

  begin
    if event_filter.transfer?
      uri = URI(@ami_callback_url)
      Net::HTTP.post_form(uri, event: event.name, data: event.headers)
    end
  rescue Exception => e
    puts e
  end
end

stream = RubyAMI::Stream.supervise_as :ami_connection, configuration['host'], configuration['port'], configuration['ami_login'], configuration['ami_password'],
                                      ->(e, stream) { handle_event e },
                                      Logger.new(STDOUT), 10

Celluloid::Actor.join(stream)

loop do
  sleep 5
end
