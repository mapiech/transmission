class Admin::CongregationsController < Admin::BaseController

  before_action -> { set_menu(:congregations) }

  def index
    @congregations = Congregation.order(:name)
  end

  def new
    @congregation = Congregation.new
  end

  def create
    @congregation = Congregation.new(congregations_attributes)
    if @congregation.save
      redirect_to admin_congregations_path, notice: "Dodano nowy zbór."
    else
      render 'new'
    end
  end

  def edit
    @congregation = Congregation.find(params[:id])
  end

  def update
    @congregation = Congregation.find(params[:id])
    if @congregation.update(congregations_attributes)
      redirect_to admin_congregations_path, notice: "Zmiany zostały pomyślnie zapisane."
    else
      render 'edit'
    end
  end

  def destroy
    @congregation = Congregation.find(params[:id])
    if @congregation.destroy
      redirect_to admin_congregations_path, notice: "Usunięto zbór."
    else
      redirect_to admin_congregations_path, notice: "Usunięcie zboru jest niemożliwe."
    end
  end

  protected

  def congregations_attributes
    params.require(:congregation).permit(
        :id, :name, :default_ip, :default_day, :default_weekend_time, :has_phone_transmission,
        :password,
        phone_transmission_attributes: [ :id, :internal_phone_number, :sip_phone_number ]
    )
  end

end
