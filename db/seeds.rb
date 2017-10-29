user = User.create(username: 'Clera', email: 'apples@orchard.com', password: 'pear', bio: 'I love apple orchards, apple sauce, and roasted beets!')

all_seasons = []
all_seasons << Season.create!(name: "Winter")
all_seasons << Season.create!(name: "Spring")
all_seasons << Season.create!(name: "Summer")
all_seasons << Season.create!(name: "Fall")

apple = Ingredient.create!(name: "Apple", description: "Things are Things are things are things")
all_seasons.each do |season|
  apple.seasons << season
  apple.posts << Post.find_or_create_by(post_type: "location", title: "Buy Beets Here", body: "111 Street Street", user: user)
  apple.posts << Post.find_or_create_by(post_type: "recipe", title: "Make Beets", body: "Beat beets until beaten. Then bring beats to bob.", user: user)
end

avocado = Ingredient.create!(name: "Avocado", description: "Things are Things are things are things")
all_seasons.each do |season|
  avocado.seasons << season
  avocado.posts << Post.find_or_create_by(post_type: "location", title: "Buy Beets Here", body: "111 Street Street", user: user)
  avocado.posts << Post.find_or_create_by(post_type: "recipe", title: "Make Beets", body: "Beat beets until beaten. Then bring beats to bob.", user: user)
end

banana = Ingredient.create!(name: "Banana", description: "Things are Things are things are things")
all_seasons.each do |season|
  banana.seasons << season
  banana.posts << Post.find_or_create_by(post_type: "location", title: "Buy Beets Here", body: "111 Street Street", user: user)
  banana.posts << Post.find_or_create_by(post_type: "recipe", title: "Make Beets", body: "Beat beets until beaten. Then bring beats to bob.", user: user)
end

beets = Ingredient.create!(name: "Beets", description: "Things are Things are things are things") # Nicks Fav!
all_seasons.each do |season|
  beets.seasons << season
  beets.posts << Post.find_or_create_by(post_type: "location", title: "Buy Beets Here", body: "111 Street Street", user: user)
  beets.posts << Post.find_or_create_by(post_type: "recipe", title: "Make Beets", body: "Beat beets until beaten. Then bring beats to bob.", user: user)
end

celery = Ingredient.create!(name: "Celery", description: "Things are Things are things are things")
all_seasons.each do |season|
  celery.seasons << season
  celery.posts << Post.find_or_create_by(post_type: "location", title: "Buy Beets Here", body: "111 Street Street", user: user)
  celery.posts << Post.find_or_create_by(post_type: "recipe", title: "Make Beets", body: "Beat beets until beaten. Then bring beats to bob.", user: user)
end

mushrooms = Ingredient.create!(name: "Mushrooms", description: "Things are Things are things are things")
all_seasons.each do |season|
  mushrooms.seasons << season
  mushrooms.posts << Post.find_or_create_by(post_type: "location", title: "Buy Beets Here", body: "111 Street Street", user: user)
  mushrooms.posts << Post.find_or_create_by(post_type: "recipe", title: "Make Beets", body: "Beat beets until beaten. Then bring beats to bob.", user: user)

################################################################################################################################################################
# DO NOT CHANGE THIS SECTION
def clean(produce)
  produce.reject! { |x| x == "Wreathes" }
  produce.reject! { |x| x == "Christmas Trees" }
end

def get_season_produce(data, a, b, c, d, e, f)
  season = data.values[a] | data.values[b] | data.values[c] | data.values[d] | data.values[e] | data.values[f]

  clean(season)
  season
end

def associate_produce(produce_data, season)
  produce_data.each do |name|
    season.ingredients << Ingredient.find_by_name(name)
  end
end

while Season.all.length < 4
  driver = Selenium::WebDriver.for :chrome
  driver.navigate.to "http://www.simplesteps.org/eat-local/state/washington"
  wait = Selenium::WebDriver::Wait.new(:timeout => 20)

  produce_data = {}

  # gets all seasons online
  seasons = wait.until {
    element_1 = driver.find_element(:class, 'state-produce')
    element_1.find_elements(:class, 'season')
  }

  # sets produce_data hash
  seasons.each do |season|
    monthy = season.find_element(:tag_name, 'h3').text

    season_produce = season.find_elements(:tag_name, 'a')

    season_produce.map! { |item| item.text }

    produce_data[monthy] = season_produce
  end

  ###############################################################################
  # SEEDS seasons & ingredients
  winter = Season.create(name: 'Winter')
  spring = Season.create(name: 'Spring')
  summer = Season.create(name: 'Summer')
  fall = Season.create(name: 'Fall')

  ingredients = produce_data.values.flatten.uniq
  clean(ingredients)

  ingredients.each do |ingredient|
    Ingredient.create(name: ingredient)
  end
  ###############################################################################

  # gets unique produce for our 4 seasons (as opposed to bi-monthly setup online)
  winter_produce_data = get_season_produce(produce_data, 0, 1, 2, 3, 22, 23)
  spring_produce_data = get_season_produce(produce_data, 4, 5, 6, 7, 8, 9)
  summer_produce_data = get_season_produce(produce_data, 10, 11, 12, 13, 14, 15)
  fall_produce_data = get_season_produce(produce_data, 16, 17, 18, 19, 20, 21)

  # associates ingredients to appropriate season
  associate_produce(winter_produce_data, winter)
  associate_produce(spring_produce_data, spring)
  associate_produce(summer_produce_data, summer)
  associate_produce(fall_produce_data, fall)


  driver.quit
end
################################################################################################################################################################
