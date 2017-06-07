class Admin::UsersController < Admin::BaseController

  before_action -> { set_menu(:users) }

  def index
    @users = User.order(:full_name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_attributes)
    if @user.save
      redirect_to admin_users_path, notice: "Użytkownik '#{@user.full_name}' od tej pory ma dostęp do transmisji."
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(users_attributes)
      redirect_to admin_users_path, notice: "Zmiany zostały pomyślnie zapisane."
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice: "Użytkownik '#{@user.full_name}' został pozbawiony dostępu do transmisji."
    else
      redirect_to admin_users_path, notice: "Usunięcie użytkownika '#{@user.full_name}' jest niemożliwe."
    end
  end

  protected

  def users_attributes
    params.require(:user).permit(
        :id, :full_name, :email, :congregation_id, :admin, :allow_join_to_any, :auto_invite_to_video,
        phone_attributes: [
            :id, :phone_number,
            phone_key_maps_attributes: [ :id, :digit, :full_name ]
        ]
    )
  end
end
