class CreateOriginalPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :original_photos do |t|
      t.timestamps
    end
  end
end
