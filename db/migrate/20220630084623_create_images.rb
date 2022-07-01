class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :file_infos do |t|
      t.string :tag, nil: false
      t.string :token, nil: false

      t.timestamps
    end

    add_index :file_infos, :tag, unique: true
  end
end
