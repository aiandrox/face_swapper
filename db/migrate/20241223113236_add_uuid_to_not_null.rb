class AddUuidToNotNull < ActiveRecord::Migration[8.0]
  def up
    change_column_null :original_photos, :uuid, false
  end

  def down
    change_column_null :original_photos, :uuid, true
  end
end
