class PersonalPhoto < ApplicationRecord
  has_one_attached :photo
  validates :name, presence: true, length: { maximum: 50 }
end
