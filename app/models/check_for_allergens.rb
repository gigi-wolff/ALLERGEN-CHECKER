def check_for_allergens(id_of_product)
  #require "pry"

  # If product exists in Reaction db, delete it so there aren't conflicting
  # results in db
  if Reaction.exists?(product_id: id_of_product)
    Reaction.where("product_id = ?", id_of_product).destroy_all
  end

  ingredients = Product.find(id_of_product).ingredients
  product_ingredients = process_ingredients_string(ingredients)

  # test each ingredient
  product_ingredients.each do |ingredient|
    # test each allergen in db 
    Allergen.find_each do |specific_allergen|
      substances = specific_allergen.substances.split(";")
      reactive_substances = ''
      substances.each do |substance|
        # if the ingredient is an allergen       
        # in specific_allergen = "Disperse Orange-3" check if ingredient is in substance="EINECS 211-984-8"
        if substance.upcase.include?(ingredient.upcase)
          reactive_substances += substance.upcase + ';'
        end
      end
      # if ingredient causes a reaction
      if !reactive_substances.empty? 
        Reaction.create(product_id: id_of_product, 
          allergen_id: specific_allergen.id, 
          reactive_substances: reactive_substances, 
          reactive_ingredient: ingredient.upcase)
      end
    end
  end
  
end
