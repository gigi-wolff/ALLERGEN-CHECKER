class Allergen < ApplicationRecord
  # dependent: :destroy, rails will destroy all reactions associated with Allergen when its deleted
  has_many  :reactions, dependent: :destroy
  has_many  :products, through: :reactions

  validates :category, presence: true, uniqueness: true, length: {minimum: 3}
  validates :substances, presence: true, length: {minimum: 3}

  # After allergen has been created or update (and saved) check all products for
  # this allergen
  after_save do |allergen|
    check_all_products_for_allergens    
  end
end