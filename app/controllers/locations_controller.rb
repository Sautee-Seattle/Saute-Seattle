require 'net/http'

class LocationsController < ApplicationController

  def index
    @ingredient = Ingredient.find(params[:ingredient_id])
    @description = "A little bird told us that you like #{@ingredient.name.pluralize(2)}. So, we decided to put together a few of our favorite #{@ingredient.name} recipes for you to check out! YOLO."
    render :index
  end

  def new
    @ingredient = Ingredient.find(params[:ingredient_id])
    render :new
  end

  def create
    if session[:user_id]
      @ingredient = Ingredient.find(params[:ingredient_id])
      @post = Post.create(post_params)
      @post.ingredients << @ingredient
      if @post.valid?
        redirect_to ingredient_path(@ingredient)
      else
        @errors = @post.errors.full_messages
        render :new
      end
    else
      redirect_to '/seasons'
    end
  end

  def show
    location = params[:id]
    @post = Post.find(location)
    @address = @post.body
    fixed_address = @address
    fixed_address.gsub!(/[\s]/, '+')
    uri = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{fixed_address}&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
    response = Net::HTTP.get_response(uri)
    hashed_response = JSON.parse(response.body)
    if hashed_response["error_message"] != nil
      sleep 1
      response = Net::HTTP.get_response(uri)
      hashed_response = JSON.parse(response.body)
    end
    @lat = hashed_response["results"][0]["geometry"]["location"]["lat"]
    @lng = hashed_response["results"][0]["geometry"]["location"]["lng"]
    render :show
  end

  def destroy
    location = Post.find(params[:id])
    user = User.find(location.user.id)
    location.destroy
    redirect_to user_path(user)
  end

  private

  def post_params
    user = User.find(session[:user_id])
    strong_params = params.require(:post).permit(:post_type, :title, :url, :body)
    strong_params[:user] = user
    strong_params
  end
end
