class Allergen < ApplicationRecord
  # dependent: :destroy, rails will destroy all reactions associated with Allergen when its deleted
  has_many  :reactions, dependent: :destroy
  has_many  :products, through: :reactions

  validates :category, presence: true, uniqueness: true, length: {minimum: 3}
  validates :substances, presence: true, length: {minimum: 3}
end