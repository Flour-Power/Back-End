class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_categories, dependent: :destroy
  has_many :categories, through: :recipe_categories

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: [:user_id]

  def category_names
    self.categories.map { |cat| cat[:name] }
  end

  def category_names=(new_categories)
    if new_categories.present?
      categories = new_categories.each.map { |cat| Category.find_by(name: cat) }
      self.categories = categories
    end
  end
end

