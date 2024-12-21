class CreateProcessedPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :processed_photos do |t|
      t.references :original_photo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
