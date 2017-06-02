require 'asterisk/ari/client'
require "json"

%w{
  phone_number_parser
  access
  ari
  ami
  cache
  base
  sync
}.each { |f| require "asterisk_wrapper/#{f}"}


module AsteriskWrapper

end