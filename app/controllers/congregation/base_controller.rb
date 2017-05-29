class Congregation::BaseController < ApplicationController

  before_action :authenticate_congregation!

  protected

end
