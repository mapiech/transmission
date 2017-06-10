class CreateCronWrappers < ActiveRecord::Migration[5.1]

  def change

    create_table :cron_wrappers do |t|
      t.timestamps
    end

  end

end
