module AsteriskWrapper
  module Ami

    @@ami = nil

    def ami
      begin
        if @@ami.status?
          return @@ami
        end
      rescue
        create_ami_connection
      end
      @@ami
    end

    def create_ami_connection
      configuration = YAML.load(File.read(File.join(Rails.root, 'config', 'asterisk.yml')))

      @@ami = RubyAsterisk::AMI.new(configuration['host'], configuration['port'])
      @@ami.login(configuration['ami_login'], configuration['ami_password'])

      def @@ami.public_execute(command, options = {})
        request = RubyAsterisk::Request.new(command, options)
        request.commands.each do |command|
          @session.write(command)
        end
        @session.waitfor('Match' => /ActionID: #{request.action_id}.*?\n\n/m) do |data|
          request.response_data << data
        end
        RubyAsterisk::Response.new(command, request.response_data)
      end

    end

  end
end