require 'rails_helper'
describe "contracts:send_renewal_email" do
  it "sends a mail to CONTRACTS expiering in a week" do
    request = Request.new(
      email: "santi@santi.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33127556789',
      first_name: "santi",
      last_name: "sanchez",
      accepted: true,
      confirmed: true,
      que_number: 1
    )

    request.save!
    contract = Contract.new
    contract.request = request
    contract.expiery_date = Date.today + 7
    contract.save!

    request = Request.new(
      email: "bea@bea.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33987654321',
      first_name: "bea",
      last_name: "cobos",
      accepted: true,
      confirmed: true,
      que_number: 2
    )
    request.save!
    contract = Contract.new
    contract.request = request
    contract.expiery_date = Date.today + 7
    contract.save!

    mails_sent_before_task = ContractMailer.deliveries.count
    #this is the code of the task
    contracts = Contract.expires_next_week
    puts "Enqueuing confirmation of #{contracts.count} contracts..."
    contracts.each do |contract|
      contract.unconfirm!
      contract.save
      ContractMailer.with(contract: contract).contract_renewal_confirmation.deliver_now
    end
    mails_sent_after_task = ContractMailer.deliveries.count
    expect(mails_sent_after_task - mails_sent_before_task).to eq(2)
  end
end
