class RecipesController < ApplicationController

  def index
    @ingredient = Ingredient.find(params[:ingredient_id])
    @description = "A little bird told us that you like #{@ingredient.name.pluralize(2)}. So, we decided to put together a few of our favorite #{@ingredient.name} recipes for you to check out!"
    render :index
  end

  def show
    @recipe = Post.find(params[:id])
    @body = @recipe.html_recipe
  end

  def new
    @recipe = Post.new
    ingredients
  end

  def create
    if session[:user_id]
      @recipe = Post.new(recipe_params)
      if params[:ingredients]
        params[:ingredients].keys.each do |name|
          @recipe.ingredients << Ingredient.find_by(name: name)
        end
      end
      if @recipe.save
        redirect_to user_recipe_path(@recipe.user, @recipe)
      else
        @errors = @recipe.errors.full_messages
        ingredients
        render :new
      end
    end
  end

  def destroy
    recipe = Post.find(params[:id])
    user = User.find(recipe.user.id)
    recipe.destroy
    redirect_to user_path(user)
  end

  private
  def recipe_params
    user = User.find(session[:user_id])
    strong_params = params.require(:post).permit(:title, :body, :image)
    strong_params[:user] = user
    strong_params[:post_type] = 'recipe'
    strong_params
  end

  def ingredients
    @ingredients = Ingredient.all
    @ingredient = Ingredient.find(params[:ingredient_id])
  end
end
