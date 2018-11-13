# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Cat.destroy_all

10.times do |x|
  Cat.create!(birth_date: '2014-06-12', name: Faker::Cat.name, color: Faker::Color.color_name, sex: ["M", "F"].sample, description: Faker::DumbAndDumber.quote)
end
