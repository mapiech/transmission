class Public::BaseController < ApplicationController

  before_action :authenticate_user!

  layout 'public'

end
