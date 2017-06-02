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
      @@ami = RubyAsterisk::AMI.new('192.168.0.15', 5038)
      @@ami.login('admin', 'Zdrojowa13')

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