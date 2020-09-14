# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



puts 'Deleting all contracts'
Contract.delete_all
puts "finished..."
puts '-----'

puts 'Deleting all requests'
Request.delete_all
puts "finished..."
puts '-----'

puts 'Generating 18 fake requests'
17.times do
  request = Request.new(
    email: Faker::Internet.email,
    bio: "this is a short bio about myself and I love playing guitar",
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
  @contract = Contract.new(expiery_date: Date.today.next_month)
  @contract.request = request
  @contract.save
end
puts "finished..."
puts '-----'

puts "Creating a request with a contract that expires in 7 days"
request = Request.new(
  email: Faker::Internet.email,
  bio: "this is a short bio about myself and I love playing guitar",
  phone_number: '+33',
  first_name: "i am a contract that expires in 7 days",
  last_name: Faker::Name.last_name,
  accepted: true,
  confirmed: true,
)
9.times do
  request.phone_number += rand(1..9).to_s
end
request.assign_que_number
request.save!
@contract = Contract.new(expiery_date: Date.today + 7, confirmed: true)
@contract.request = request
@contract.save
puts "finished..."
puts '-----'

puts "Creating a request with a provisional contract that expires today"
request = Request.new(
  email: Faker::Internet.email,
  bio: "this is a short bio about myself and I love playing guitar",
  phone_number: '+33',
  first_name: "i am a provisional contract that expired today",
  last_name: Faker::Name.last_name,
  accepted: true,
  confirmed: true,
)
9.times do
  request.phone_number += rand(1..9).to_s
end
request.assign_que_number
request.save!
@contract = Contract.new(expiery_date: Date.today, confirmed: false, provisional: true)
@contract.request = request
@contract.save
puts "finished..."
puts '-----'

puts "Creating a request with a contract that expires today and hasn't been confirmed for renewal"
request = Request.new(
  email: Faker::Internet.email,
  bio: "this is a short bio about myself and I love playing guitar",
  phone_number: '+33',
  first_name: "i am a contract that expired today",
  last_name: Faker::Name.last_name,
  accepted: true,
  confirmed: true,
)
9.times do
  request.phone_number += rand(1..9).to_s
end
request.assign_que_number
request.save!
@contract = Contract.new(expiery_date: Date.today, confirmed: false)
@contract.request = request
@contract.save
puts "finished..."
puts '-----'

puts "Creating 2 requests on que"
request_santi = Request.new(
  email: "santi@santi.com",
  bio: "this is a short bio about myself and I love playing guitar",
  phone_number: '+33',
  first_name: "santiago",
  last_name: "sanchez",
  confirmed: true,
)
9.times do
  request_santi.phone_number += rand(1..9).to_s
end
request_santi.assign_que_number
request_santi.save!


puts "Creating a request that expires in 7 days"
request_bea = Request.new(
  email: "bea@bea.com",
  bio: "this is a short bio about myself and I love playing guitar",
  phone_number: '+33',
  first_name: "i am a request that expiers in 7 days",
  last_name: "cobos",
  expiery_date: Date.today + 7,
  confirmed: true,
)
9.times do
  request_bea.phone_number += rand(1..9).to_s
end
request_bea.assign_que_number
request_bea.save!


puts "Congratulations you now have #{Request.count} requests and #{Contract.count} contracts"
puts "End of seeds"
puts '-----------'
