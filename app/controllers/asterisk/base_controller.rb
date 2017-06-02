class Asterisk::BaseController < ApplicationController

  skip_before_action :verify_authenticity_token

  layout false

end
