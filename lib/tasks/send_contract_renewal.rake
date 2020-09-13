namespace :requests do

  #This task should be daily
  desc "Sends 'Still interested in our services' email"
  task send_renewal_email: :environment do
    requests = Request.unaccepted_and_still_interested
    puts "Enqueuing confirmation of #{requests.count} requests..."
    requests.each do |request|
      RenewRequestJob.perform_later(request.id)
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
      RenewContractJob.perform_later(contract.id)
    end
  end

  #This task should be daily
  desc "Mark all due date contracts as expired"
  task mark_expired: :environment do
    contracts = Contract.today_expires_and_unconfirmed
    puts "Enqueuing expiery of #{contracts.count} contracts..."
    contracts.each do |contract|
      ExpiredContractJob.perform_later(contract.id)
    end
  end
end
