class Public::HomeController < Public::BaseController

  skip_before_action :authenticate_user!
  before_action :block_if_user_signed_in, if: :user_signed_in?

  def index
    render
  end

  protected

  def block_if_user_signed_in
    redirect_to after_sign_in_path_for(:user)
  end

end
