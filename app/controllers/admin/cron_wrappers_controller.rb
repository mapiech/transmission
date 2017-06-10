class Admin::CronWrappersController < Admin::BaseController

  before_action -> { set_menu(:cron_wrappers) }

  def show
    @cron_wrapper = CronWrapper.includes(:cron_entries).last
  end

  def edit
    @cron_wrapper = CronWrapper.includes(:cron_entries).last
  end

  def update
    @cron_wrapper = CronWrapper.includes(:cron_entries).last
    if @cron_wrapper.update(cron_wrapper_attributes)
      redirect_to admin_cron_wrappers_path
    else
      render 'edit'
    end
  end

  protected

  def cron_wrapper_attributes
    params.require(:cron_wrapper).permit(
      :id,
      cron_entries_attributes: [ :id, :action_label, :day_label, :hour_label, :minute_label, :_destroy ]
    )
  end
end
