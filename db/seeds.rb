# Create users
user_alex = User.create! email: 'alex@test', password: 'test@test', password_confirmation: 'test@test', first_name: 'Alex', phone: '0611223344'
user_zoe = User.create! email: 'zoe@test', password: 'test@test', password_confirmation: 'test@test', first_name: 'Zoé', phone: '0699887766'

# Cities
city_paris = City.create! name: 'Paris', latitude: 48.864716, longitude: 2.349014

# Tags
tag_sport = Tag.create! label: 'Sportif'
tag_creative = Tag.create! label: 'Créatif'
tag_cook = Tag.create! label: 'Cuisine'
tag_travel = Tag.create! label: 'Voyage'

# Friends
friend_bastien = Friend.create!(
  first_name: 'Bastien',
  birthday: Date.new(1980, 1, 1),
  is_male: true,
  description: 'Son nom est Bastien',
  city: city_paris,
  user: user_alex
)

friend_yvan = Friend.create!(
  first_name: 'Yvan',
  birthday: Date.new(1981, 12, 30),
  is_male: true,
  description: 'Voici Yvan',
  city: city_paris,
  user: user_zoe
)

# First tags
TagRelation.create! exchange: nil, tag: tag_travel, friend: friend_bastien
TagRelation.create! exchange: nil, tag: tag_sport, friend: friend_bastien
TagRelation.create! exchange: nil, tag: tag_creative, friend: friend_yvan

# Old exchange
exchange_old = Exchange.create! is_active: false, friend1: friend_yvan, friend2: friend_bastien
TagRelation.create! exchange: exchange_old, tag: tag_sport, friend: friend_bastien
TagRelation.create! exchange: exchange_old, tag: tag_sport, friend: friend_yvan
TagRelation.create! exchange: exchange_old, tag: tag_creative, friend: friend_yvan
TagRelation.create! exchange: exchange_old, tag: tag_cook, friend: friend_yvan

# Current exchange
Exchange.create! is_active: true, friend1: friend_bastien, friend2: friend_yvan
