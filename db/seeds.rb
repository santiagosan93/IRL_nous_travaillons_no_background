# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


if Rails.env.development?

  puts 'Deleting all contracts'
  Contract.delete_all
  puts "finished..."
  puts '-----'

  puts 'Deleting all requests'
  Request.delete_all
  puts "finished..."
  puts '-----'

  puts 'Generating 18 fake requests'
  18.times do
    request = Request.new(
      email: Faker::Internet.email,
      bio: "this is a short bio about myself",
      phone_number: '+33',
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      accepted: true,
      confirmed: true,
    )
    9.times do
      request.phone_number += rand(1..9).to_s
    end
    request.assign_que_number
    request.save!
    Contract.create(expiery_date: Date.today.next_month)
  end
  puts "finished..."
  puts '-----'

  puts "Congratulations you now have #{Request.count} requests"
  puts "End of seeds"
  puts '-----------'
end
