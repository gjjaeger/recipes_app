class Recipe < ActiveRecord::Base
  has_many :ingredients
  has_many :recipes_tags
  has_many :tags, through: :recipes_tags
  has_many :ratings
end
