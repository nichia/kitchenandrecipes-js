module RecipesHelper

  def link_to_image_tag(recipe)
    if current_user == recipe.user
      link_to image_tag(recipe.image, class: "card-img-top"), user_recipe_path(current_user, recipe)
    else
      link_to image_tag(recipe.image, class: "card-img-top"), recipe_path(recipe)
    end
  end

  def link_to_recipe_name(recipe)
    if current_user == recipe.user
       link_to recipe.name.titleize, user_recipe_path(current_user, recipe)
    else
       link_to recipe.name.titleize, recipe_path(recipe)
    end
  end

  def sort_recipe_ingredients(recipe, object_id = nil)
    recipe.recipe_ingredients.ordered_recipe_ingredients if object_id
  end

  def sort_instructions(recipe, object_id = nil)
    recipe.instructions.ordered_instructions if object_id
  end

  def link_to_recipe_actions(recipe)
    if current_user == recipe.user
      link_to("Edit Recipe", edit_user_recipe_path(current_user, recipe), class: 'btn btn-primary') + " " +
      link_to("Delete Recipe", user_recipe_path(recipe), method: :delete, data: { confirm: "Are you sure you want to delete this recipe?" }, class: 'btn btn-danger')
    elsif current_user
      link_to("Clone Recipe", recipe_copy_path(recipe), method: :post, data: { confirm: "Are you sure you want to clone this recipe?" }, class: 'btn btn-primary')
    end
  end

end
