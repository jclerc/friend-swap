# Dataset
users_count = 20
friends_count = 200

first_names_male = %w[
  Jules Léo Maël Gabriel Raphaël Sacha Hugo Ethan Arthur Nathan Louis
  Lucas Tom Liam Gabin Paul Clément Théo Noé Antoine Nolan Axel Valentin
  Mathis Maxence Timéo Baptiste Noah Aaron Eliott Maxime Martin Victor
  Enzo Marius Robin Malo Samuel Alexis Estéban Mathéo Thomas Léon Noa
  Sasha Adam Marceau Antonin Augustin Mahé
]

first_names_female = %w[
  Emma Louise Léna Chloé Camille Manon Jade Alice Léa Zoé Lola Mila
  Julia Inès Agathe Juliette Lucie Élise Eden Rose Ambre Mia Éléna
  Léonie Lou Anna Margaux Léana Clémence Capucine Clara Eva Romane
  Mathilde Soline Jeanne Maëlys Charlotte Noémie Nina Olivia Justine
  Lilou Louna Candice Emy Giulia Elsa Charlie Léane
]

first_names = first_names_male + first_names_female

descriptions = [
  'Son nom est %s.',
  'Voici %s.',
  'Description de %s.',
  '%s est dispo.'
]

# Create users
puts "Creating #{users_count} users..."
User.create!(email: 'test@test', password: 'test@test',
             password_confirmation: 'test@test', first_name: 'Admin',
             phone: '0600000000', is_admin: true)

users = []
users_count.times do
  first_name = first_names.sample
  users << User.create!(email: "#{first_name.parameterize}.#{rand(1..999)}@gmail.com",
                        password: 'test@test',
                        password_confirmation: 'test@test',
                        first_name: first_name,
                        phone: "06#{format('%08d', rand(10**8))}")
end

# Cities
puts 'Creating 4 cities...'
cities = []
cities << City.create!(name: 'Paris', latitude: 48.86471, longitude: 2.34901)
cities << City.create!(name: 'Lyon', latitude: 45.74846, longitude: 4.84671)
cities << City.create!(name: 'Toulouse', latitude: 43.60426, longitude: 1.44367)
cities << City.create!(name: 'Bordeaux', latitude: 44.83615, longitude: -0.58081)

# Tags
puts 'Creating 15 tags...'
tags = []
tags << Tag.create!(label_male: 'Sportif', label_female: 'Sportive')
tags << Tag.create!(label_male: 'Créatif', label_female: 'Créative')
tags << Tag.create!(label_male: 'Cuisine', label_female: 'Cuisine')
tags << Tag.create!(label_male: 'Voyage', label_female: 'Voyage')
tags << Tag.create!(label_male: 'Drôle', label_female: 'Drôle')
tags << Tag.create!(label_male: 'Rapide', label_female: 'Rapide')
tags << Tag.create!(label_male: 'Musclé', label_female: 'Musclée')
tags << Tag.create!(label_male: 'Intelligent', label_female: 'Intelligente')
tags << Tag.create!(label_male: 'Grand', label_female: 'Grande')
tags << Tag.create!(label_male: 'Petit', label_female: 'Petite')
tags << Tag.create!(label_male: 'Patient', label_female: 'Patiente')
tags << Tag.create!(label_male: 'Sympa', label_female: 'Sympa')
tags << Tag.create!(label_male: 'Corrosif', label_female: 'Corrosive')
tags << Tag.create!(label_male: 'Méchant', label_female: 'Méchante')
tags << Tag.create!(label_male: 'Lent', label_female: 'Lente')

# Friends
puts "Creating #{friends_count} friends, linked to ~#{friends_count * 3} tags..."
friends = []
date_min = Date.new(2000, 12, 12)
date_max = Date.new(1990, 1, 1)
i = 0
friends_count.times do
  i += 1
  male = i <= friends_count / 2
  img = (male ? "male/#{i}" : "female/#{i-100}") + '.jpg'
  first_name = (male ? first_names_male : first_names_female).sample
  date = (date_min + (date_max - date_min) * rand).to_date
  friends << Friend.create!(
    avatar: File.new("#{Rails.root}/app/assets/images/seeds/friends/#{img}"),
    first_name: first_name,
    birthday: date,
    is_male: male,
    description: format(descriptions.sample, first_name),
    city: cities.sample,
    user: users.sample,
    tag_relations_attributes: (tags.sample(rand(2..4)).map { |tag| { tag_id: tag.id } })
  )
end

# Old exchanges
exchanges_created = (friends_count * 0.5 * (1 + 5) / 2).floor
tags_created = exchanges_created * (2 + 5)
puts "Creating ~#{exchanges_created} exchanges"\
     ", linked to ~#{tags_created} tags..."
friends.sample(friends_count * 0.5).each do |friend|
  rand(1..5).times do
    other_friend = friends.sample(20).detect { |other| other.id != friend.id && other.user_id != friend.user_id }
    exchange_old = Exchange.create! is_active: false,
                                    friend1: friend,
                                    friend2: other_friend

    [friend, other_friend].each do |f|
      tags.sample(rand(2..5)).each do |tag|
        TagRelation.create! exchange: exchange_old, tag: tag, friend: f
      end
    end
  end
end

# Current exchanges
puts "Creating #{(friends.size / 4).floor} active exchanges..."
friends.sample(friends.size / 2).each_slice(2).each do |a, b|
  Exchange.create! is_active: true, friend1: a, friend2: b if b and a.user != b.user
end

puts 'Done!'
