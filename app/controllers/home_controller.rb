class HomeController < ApplicationController

  include CongregationDeviseHelper

  before_action :only_local_ips_or_admin!
  before_action :block_if_congregation_signed_in, if: :congregation_signed_in?

  layout 'application'

  def index
    render
  end

  protected

  def block_if_congregation_signed_in
    redirect_to after_sign_in_path_for(:congregation)
  end

end
