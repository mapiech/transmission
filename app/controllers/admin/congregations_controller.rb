require 'fileutils'

class Admin::CongregationsController < Admin::BaseController

  before_action -> { set_menu(:congregations) }

  def index
    @congregations = Congregation.order(:name)
    @admins = User.where(admin: true)
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

  def edit_password
    @congregation = Congregation.find(params[:id])
  end

  def update_password
    @congregation = Congregation.find(params[:id])
    if @congregation.update(congregations_password_attributes)
      redirect_to admin_congregations_path, notice: "Hasło zostało pomyślnie zmienione."
    else
      render 'edit_password'
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

  def reset_stream
    @congregation = Congregation.find(params[:id])

    begin
      if @congregation.reset_stream!
        redirect_to admin_congregations_path, notice: "Stream został zresetowany."
      else
        redirect_to admin_congregations_path, alert: "Nie udało się zresetować streamu."
      end
    rescue
      redirect_to admin_congregations_path, alert: "Nie udało się zresetować streamu."
    end
  end

  def reset_broadcasts
    @congregation = Congregation.find(params[:id])

    begin
      if @congregation.reset_broadcasts!
        redirect_to admin_congregations_path, notice: "Tramisje wideo zostały zresetowane."
      else
        redirect_to admin_congregations_path, alert: "Nie udało się zresetować transmisji."
      end
    rescue
      redirect_to admin_congregations_path, alert: "Nie udało się zresetować transmisji."
    end
  end

  def reset_phone_sync
    begin
      FileUtils.rm(File.join(Rails.root, 'asterisk-sync', 'server.rb.pid'))
    rescue
    end
    redirect_to admin_congregations_path, notice: "Restartuję Synchronizację połączeń."    
  end

  protected

  def congregations_attributes
    params.require(:congregation).permit(
        :id, :name, :default_ip, :default_day, :default_weekend_time, :has_phone_transmission, :has_video_transmission,
        :password,
        phone_transmission_attributes: [ :id, :internal_phone_number, :sip_phone_number ],
        video_transmission_attributes: [ :id ]
    )
  end

  def congregations_password_attributes
    params.require(:congregation).permit(
        :id, :password
    )
  end

end
