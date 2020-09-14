require 'rails_helper'
describe "Contract" do
  it "generates defaults as expected" do
    request = Request.create!(
      email: "no@name.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33123456789',
      first_name: "unique email",
      last_name: "no name",
      accepted: true,
      confirmed: true,
    )
    contract = Contract.new
    contract.request = request
    contract.save
    expect(contract.expired).to eq(false)
    expect(contract.confirmed).to eq(true)
    expect(contract.provisional).to eq(false)
  end
end

#Comment for glory
