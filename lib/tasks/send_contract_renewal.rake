namespace :requests do

  #This task should be daily
  desc "Sends 'Still interested in our services' email"
  task send_renewal_email: :environment do
    requests = Request.unaccepted_and_still_interested
    puts "Enqueuing confirmation of #{requests.count} requests..."
    requests.each do |request|
      request.confirmed = false
      request.save
      RequestMailer.with(request: request).request_renewal_confirmation.deliver_now
    end
  end
end


namespace :contracts do

  #This task should be daily
  desc "Sends contract renewal email"
  task send_renewal_email: :environment do
    contracts = Contract.expires_next_week
    puts "Enqueuing confirmation of #{contracts.count} contracts..."
    contracts.each do |contract|
      contract.unconfirm!
      contract.save
      ContractMailer.with(contract: contract).contract_renewal_confirmation.deliver_now
    end
  end

  #This task should be daily
  desc "Mark all due date contracts as expired"
  task mark_expired: :environment do
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
end

task daily: ["contracts:mark_expired", "contracts:send_renewal_email", "requests:send_renewal_email"]
