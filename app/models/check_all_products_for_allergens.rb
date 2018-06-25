def check_all_products_for_allergens
  # make sure there are products in db
  if Product.any?
    Product.pluck(:id).each do |product_id| 
        check_for_allergens(product_id)
    end
  else
    return
  end
end