class CreateCronEntries < ActiveRecord::Migration[5.1]

  def change

    create_table :cron_entries do |t|
      t.integer :cron_wrapper_id
      t.string :action_label
      t.string :day_label
      t.string :hour_label
      t.string :minute_label
      t.timestamps
    end

  end

end
