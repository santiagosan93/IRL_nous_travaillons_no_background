require 'rails_helper'
describe "requests:send_renewal_email" do
  it "sends a mail to REQUESTS expiering in a week" do
    request = Request.new(
      email: "santi@santi.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33127556789',
      first_name: "santi",
      last_name: "sanchez",
      accepted: false,
      confirmed: true,
      expiery_date: Date.today + 7,
      que_number: 21
    )

    request.save!

    request = Request.new(
      email: "bea@bea.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33987654321',
      first_name: "bea",
      last_name: "cobos",
      accepted: false,
      confirmed: true,
      expiery_date: Date.today + 7,
      que_number: 22
    )
    request.save!
    mails_sent_before_task = RequestMailer.deliveries.count
    #this is the code of the task
    requests = Request.unaccepted_and_still_interested
    puts "Enqueuing confirmation of #{requests.count} requests..."
    requests.each do |request|
      request.confirmed = false
      request.save
      RequestMailer.with(request: request).request_renewal_confirmation.deliver_now
    end
    mails_sent_after_task = RequestMailer.deliveries.count
    expect(mails_sent_after_task - mails_sent_before_task).to eq(2)
  end
end
