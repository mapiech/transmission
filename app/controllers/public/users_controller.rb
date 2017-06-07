class Public::UsersController < Public::BaseController

  def counter
    current_user.set_count(params[:count])
    render plain: 'count'
  end

end
