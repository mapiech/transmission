class Admin::BaseController < ApplicationController

  #before_action :only_local_ips_or_admin!
  before_action :authenticate_admin!

end
