class CreatePersonalPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :personal_photos do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
