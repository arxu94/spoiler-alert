# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
require 'faker'
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Food.destroy_all
User.destroy_all

user = User.create!(
    nickname: Faker::Name.name,
    open_id: rand(1..200)
    )

foodtags = Food.new(tag_list: ["Meat and Fish", "Dairy", "Fruits and Veggies", "Condiments", "Eggs", "Others"], user: user)
foodtags.save!

# 10.times do
#   user = User.create!(
#     nickname: Faker::Name.name,
#     open_id: rand(1..200)
#     )

#   food = Food.create!(
#   user: user,
#   name: Faker::Food.vegetables,
#   status: true,
#   shelf_life: rand(1..15),
#   photo: "https://source.unsplash.com/800x400/?groceries,meat,vegetables,fruits",
#   purchase_date: Faker::Date.backward(days: 10)
#     )
# end
