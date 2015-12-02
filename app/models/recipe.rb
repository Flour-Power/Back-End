class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_categories, dependent: :destroy
  has_many :categories, through: :recipe_categories
  has_many :directions
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: [:user_id]

  def category_names
    self.categories.map { |cat| cat[:name] }
  end

  def category_names=(new_categories)
   categories = new_categories.each.map { |cat| Category.find_by!(name: cat) }
   self.categories = categories
  end

  def steps
    self.directions.order(:id).map { |step| step[:step] }
  end

  def steps=(new_steps)
    steps = new_steps.each.map { |step| self.directions.create(step: step) }
    self.directions = steps
  end

  def ingredient_amounts
    self.ingredients.map { |item| [item[:name], item[:amount], item[:unit]] }
  end

  def ingredient_amounts=(new_amounts)
    binding.pry
    new_amounts.each do | item |
      ingredient = Ingredient.find_or_create_by!(name: item[:name])
      self.recipe_ingredients.create!(ingredient_id: ingredient.id,
                               amount: item[:amount],
                               unit: item[:unit])
    end
    self.recipe_ingredients
  end
end

