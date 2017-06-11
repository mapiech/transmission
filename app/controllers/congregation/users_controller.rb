class Congregation::UsersController < Congregation::BaseController

  before_action -> { set_menu(:users) }

  def index
    @users = current_congregation.users.where(admin: false).order(:full_name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_attributes)
    @user.congregation = current_congregation
    if @user.save
      redirect_to congregation_users_path, notice: "Użytkownik '#{@user.full_name}' od tej pory ma dostęp do transmisji."
    else
      render 'new'
    end
  end

  def edit
    @user = current_congregation.users.find(params[:id])
  end

  def update
    @user = current_congregation.users.find(params[:id])
    if @user.update(users_attributes)
      redirect_to congregation_users_path, notice: "Zmiany zostały pomyślnie zapisane."
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_congregation.users.find(params[:id])
    if @user.congregation_can_remove_user? and  @user.destroy
      redirect_to congregation_users_path, notice: "Użytkownik '#{@user.full_name}' został pozbawiony dostępu do transmisji."
    else
      redirect_to congregation_users_path, alert: "Usunięcie użytkownika '#{@user.full_name}' jest niemożliwe."
    end
  end

  def sms
    @user = current_congregation.users.find(params[:id])
    @user.send_transmission_number!
    redirect_to congregation_users_path, notice: 'Wysłano SMS.'
  end

  protected

  def users_attributes
    params.require(:user).permit(
        :id, :full_name, :email, :auto_invite_to_video,
        phone_attributes: [
            :id, :phone_number,
            phone_key_maps_attributes: [ :id, :digit, :full_name ]
        ]
    )
  end

end
