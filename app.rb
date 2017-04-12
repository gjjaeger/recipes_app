require('pry')
require("bundler/setup")
require('pg')

DB = PG.connect({:dbname => "recipe_development"})
  Bundler.require(:default)

  Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
  also_reload("lib/*.rb")

get('/') do
  # average_rating= @recipe.ratings.average("score").to_f
  @toprecipes = DB.exec("select recipes.* ,avg(score) from ratings join recipes on (recipes.id = ratings.recipe_id) group by recipes.id order by avg(score) desc;")
  @recipes = Recipe.all()
  @ratings = Rating.all
  @ingredients = Ingredient.all
  @tags = Tag.all
  erb(:index)
end

get ('/recipe/:id/view/?') do
  @recipe=Recipe.find(Integer(params.fetch('id')))


  @average_rating= @recipe.ratings.average("score").to_f
  @add_new_tag = params[:add_new_tag]
  @tags = Tag.all()
  erb(:recipe_view)
end

post ('/recipe') do
  name = params.fetch('name')
  instructions = params.fetch('instructions')
  recipe = Recipe.create({:name => name, :instructions => instructions})
  redirect ('/')
end

post ('/ingredient') do
  recipe_id = Integer(params.fetch('recipe_id'))
  ingredient = params.fetch('ingredient')
  ing = Ingredient.create({:name=>ingredient,:recipe_id => recipe_id})
  redirect("/recipe/#{recipe_id}/view/?")
end

delete ('/ingredient') do
  recipe_id=Integer(params.fetch("recipe_id"))
  ingredient_to_be_deleted= Ingredient.find(Integer(params.fetch('ingredient_id')))
  ingredient_to_be_deleted.delete
  redirect("/recipe/#{recipe_id}/view/?")
end

post ('/tag') do
  recipe_id = Integer(params.fetch('recipe_id'))
  recipe=Recipe.find(recipe_id)
  tag = Tag.new(:name => params.fetch('tag'))
  RecipesTag.create(recipe: recipe, tag: tag)
  tag.delete()
  redirect("/recipe/#{recipe_id}/view/?")
end

post ('/tag/new') do
  recipe_id = Integer(params.fetch('recipe_id'))
  recipe=Recipe.find(recipe_id)
  tag_name = params.fetch('tag')
  tag = Tag.create({:name=>tag_name})
  RecipesTag.create(recipe: recipe, tag: tag)
  redirect("/recipe/#{recipe_id}/view/?")
end

delete ('/tag') do
  recipe_id=Integer(params.fetch("recipe_id"))
  tag_id=Integer(params.fetch("tag_id"))
  tag_to_be_deleted= Tag.find(Integer(params.fetch('tag_id')))
  tag_to_be_deleted.destroy()
  redirect("/recipe/#{recipe_id}/view/?")
end

post ('/rating') do
  recipe_id = Integer(params.fetch('recipe_id'))
  name = params.fetch('user_name')
  rating = Integer(params.fetch('rating'))
  ing = Rating.create({:name => name,:score=>rating,:recipe_id => recipe_id})
  redirect("/recipe/#{recipe_id}/view/?")
end
