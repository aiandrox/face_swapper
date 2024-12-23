class AddUuidToOriginalPhotos < ActiveRecord::Migration[8.0]
  def change
    add_column :original_photos, :uuid, :string
    add_index :original_photos, :uuid, unique: true
  end
end
