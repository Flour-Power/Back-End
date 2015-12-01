class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipe = current_user.recipes.find_by!(id: params[:id])

    render "index.json.jbuilder", status: :ok
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      render "create.json.jbuilder", status: :created
    else
      render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
    end

    ## TODO add additional creates here once other models are created
  end

  def update
    recipe = current_user.recipes.find_by!(id: params[:id])

    recipe.update(name: params[:name])

    if recipe.errors.blank?
      render json: { success: "true" }, status: :ok
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = current_user.recipes.find_by!(id: params[:id])

    recipe.destroy

    render json: { success: "true" }, status: :ok
  end

  private
  def recipe_params
    params.permit(:name)
  end
end