require 'rails_helper'
describe "Request" do
  it "has a first_name" do
    request = Request.new(first_name: "Santi")
    expect(request.first_name).to eq("Santi")
  end

  it "first_name cannot be blank" do
    request = Request.new(
      email: "no@name.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33123456789',
      # first_name: "unique email",
      last_name: "no name",
      accepted: true,
      confirmed: true,
    )
    expect(request).not_to be_valid
  end

  it "last_name cannot be blank" do
    request = Request.new(
      email: "no@name.com",
    # bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33',
      first_name: "unique email",
      # last_name: "no name",
      accepted: true,
      confirmed: true,
    )
    expect(request).not_to be_valid
  end

  it "email is unique" do
    request = Request.new(
      email: "unique@mail.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33123456789',
      first_name: "unique email",
      last_name: "unique email",
      accepted: true,
      confirmed: true,
    )
    request.assign_que_number
    request.save!
    request = Request.new(email: "unique@mail.com")
    expect(request).not_to be_valid
  end

  it "Person can reapply with same email if prev request had expired" do
    request = Request.new(
      email: "unique@mail.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33123456789',
      first_name: "unique email",
      last_name: "unique email",
      accepted: false,
      confirmed: false,
      expired: true,
      que_number: nil
    )
    request.save!
    request = Request.new(
      email: "unique@mail.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33',
      first_name: "unique email",
      last_name: "unique email",
      accepted: false,
      confirmed: false,
      expired: false,
      que_number: nil
    )
    9.times do
      request.phone_number += rand(1..9).to_s
    end
    expect(request).to be_valid
  end



  it "can have a contract" do
    request = Request.new(
      email: "unique@mail.com",
      bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33',
      first_name: "unique email",
      last_name: "unique email",
      accepted: true,
      confirmed: true,
    )
    9.times do
      request.phone_number += rand(1..9).to_s
    end
    request.assign_que_number
    request.save!
    expect(request).to respond_to(:contract)
    expect(request.contract).to eq(nil)
  end

  it "bio can't be blank" do
    request = Request.new(
      email: "unique@mail.com",
      # bio: "this is a short bio about myself and I love playing guitar",
      phone_number: '+33',
      first_name: "unique email",
      last_name: "unique email",
      accepted: true,
      confirmed: true,
    )
    9.times do
      request.phone_number += rand(1..9).to_s
    end
    request.assign_que_number
    expect(request).not_to be_valid
  end

  describe "phone_number validations" do
    it "passes true for '+33123456789' (Normal french number)" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '+33 1 23 45 67 89',
        first_name: "unique email",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).to be_valid
    end

    it "passes true for '+33 1 23 45 67 89' (with spaces)" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '+33 1 23 45 67 89',
        first_name: "unique email",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).to be_valid
    end

    it "passes true for '0 1 23 45 67 89' (starts with 0 instead of + 33)" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '0 1 23 45 67 89',
        first_name: "unique email",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).to be_valid
    end

    it "passes false for '0 1 20 45 67 89' (has a 0 other than the first one)" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '0 1 20 45 67 89',
        first_name: "unique email",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).not_to be_valid
    end

    it "passes false for '+45 1 20 45 67 89' (Has another indicative)" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '+45 1  20 45 67 89',
        first_name: "unique email",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).not_to be_valid
    end

    it "passes false for '+33 67 89' (Not enough numbers)" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '0  20 45 67 89',
        first_name: "unique email",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).not_to be_valid
    end

    it "passes false for '+33 67 89 98 98 98 98' (To many numbers)" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '+33 67 89 98 98 98 98',
        first_name: "unique email",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).not_to be_valid
    end

  end

  describe "Name format validations" do
    it "Must be at least two letters" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '0 1 23 45 67 89',
        first_name: "a",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).not_to be_valid
    end

    it "Must be at max 60 letters" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is a short bio about myself and I love playing guitar",
        phone_number: '0 1 23 45 67 89',
        # there are 25 'a's in there
        first_name: "a" * 60 + "a",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).not_to be_valid
    end

    # it "Must not contain special caracters" do
    #   request = Request.new(
    #     email: "unique@mail.com",
    #     bio: "this is a short bio about myself and I love playing guitar",
    #     phone_number: '0 1 23 45 67 89',
    #     first_name: "santiago_jose",
    #     last_name: "unique email",
    #     accepted: true,
    #     confirmed: true,
    #   )
    #   request.assign_que_number
    #   request.remove_spaces_of_phone_number
    #   expect(request).not_to be_valid
    # end
  end

  # laskdjflaskdjflakdsfj

  describe "Bio validations" do
    it "Should be at least 50 characters" do
      request = Request.new(
        email: "unique@mail.com",
        bio: "this is",
        phone_number: '0 1 23 45 67 89',
        first_name: "santiago_jose",
        last_name: "unique email",
        accepted: true,
        confirmed: true,
      )
      request.assign_que_number
      request.remove_spaces_of_phone_number
      expect(request).not_to be_valid
    end
  end
end



