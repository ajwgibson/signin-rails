class CreateSignInRecordImports < ActiveRecord::Migration[5.1]
  def change
    create_table :sign_in_record_imports do |t|
      t.integer    :status,       null: false, default: 0
      t.integer    :success_count
      t.integer    :error_count
      t.attachment :upload_file
      t.attachment :error_file
      t.timestamps
    end
  end
end
