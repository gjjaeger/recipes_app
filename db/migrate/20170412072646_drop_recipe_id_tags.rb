class DropRecipeIdTags < ActiveRecord::Migration[5.0]
  def change
    remove_column(:tags, :recipe_id)
  end
end
