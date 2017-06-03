module AsteriskWrapper

  module Ari

    @@ari = nil

    def ari
      @@ari ||= create_client
    end

    def create_client
      configuration = YAML.load(File.read(File.join(Rails.root, 'config', 'asterisk.yml')))
      ::Ari::Client.new({
                            url: configuration['ari_host'],
                            api_key: configuration['ari_api_key']
                        })
    end

  end

end