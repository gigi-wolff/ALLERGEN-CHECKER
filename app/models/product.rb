class Product < ApplicationRecord
  # dependent: :destroy, rails will destroy all reactions associated with Product when its deleted
  has_many  :reactions, dependent: :destroy
  has_many  :allergens, through: :reactions

  validates :name, presence: true, uniqueness: true, length: {minimum: 3}
  validates :ingredients, presence: true, length: {minimum: 3}
end

