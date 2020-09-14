class TasksController < ApplicationController
  def seed
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
  end

  def contracts_mark_expired
    contracts = Contract.today_expires_and_unconfirmed
    puts "Enqueuing expiery of #{contracts.count} contracts..."
    contracts.each do |contract|
      contract.expire!
      contract.save
      request = contract.request
      request.remove_from_que!
      request.unaccept!
      request.unconfirm!
      request.expire!
      request.save
      ContractMailer.with(contract: contract).contract_expired.deliver_now
    end
    Request.calculate_que_number
  end

  def contracts_send_renewal_email
    contracts = Contract.expires_next_week
    puts "Enqueuing confirmation of #{contracts.count} contracts..."
    contracts.each do |contract|
      contract.unconfirm!
      contract.save
      ContractMailer.with(contract: contract).contract_renewal_confirmation.deliver_now
    end
  end

  def requests_send_renewal_email
    requests = Request.unaccepted_and_still_interested
    puts "Enqueuing confirmation of #{requests.count} requests..."
    requests.each do |request|
      request.confirmed = false
      request.save
      RequestMailer.with(request: request).request_renewal_confirmation.deliver_now
    end
  end
end
