class CreateSignInRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :sign_in_records do |t|
      t.string     :first_name,   null: false
      t.string     :last_name,    null: false
      t.string     :room,         null: false
      t.datetime   :sign_in_time, null: false
      t.string     :label,        null: false
      t.boolean    :newcomer,     null: false, default: false
      t.timestamps
    end
  end
end
