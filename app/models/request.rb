class Request < ApplicationRecord
  after_create :send_confirmation_email

  validates :first_name, :last_name, :email, :bio, :phone_number, presence: true
  validates :email, uniqueness: true

  validates :phone_number, format: {
    with: /^((\+)33|0)[1-9](\d{2}){4}$/,
    message: "- Make sure you're typing in a french number", multiline: true
  }

  validates :email, format: {
    with: /([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/,
    message: "- You've entered an invalid email"
  }

  has_one :contract

  def renew_expiery_date
    self.expiery_date = Date.today.next_month(3)
  end

  def remove_spaces_of_phone_number
    self.phone_number = self.phone_number.gsub(' ', '')
  end

  def assign_que_number
    if Request.all.empty?
      self.que_number = 1
    else
      self.que_number = Request.maximum(:que_number) + 1
    end
  end

  def expire!
    self.expired = true
  end

  def remove_from_que!
    self.que_number = nil
  end

  def has_que_number
    !(self.que_number.nil?)
  end

  def confirm!
    self.confirmed = true
  end

  def unconfirm!
    self.confirmed = false
  end

  def accept!
    self.accepted = true
  end

  def unaccept!
    self.accepted = false
  end

  def self.calculate_que_number
    requests = Request.not_expired.order(:que_number)
    Request.reassign_que_numbers(requests)
    new_requests = Request.where(accepted: false).where("que_number <= 20")
    Request.send_contract_to_new_accepted_requests(new_requests)
  end

  def self.unconfirmed
    Request.where(confirmed: false)
  end

  def self.confirmed
    Request.where(confirmed: true)
  end

  def self.accepted
    Request.where(accepted: true)
  end

  def self.not_expired
    Request.where(expired: false)
  end

  def self.expired
    Request.where(expired: true)
  end

  def self.unaccepted_and_still_interested
    Request.where(accepted: false, expired: false, expiery_date: Date.today + 7)
  end

  private

  def send_confirmation_email
    RequestMailer.with(request: self).confirmation.deliver_now
  end

  def self.send_contract_to_new_accepted_requests(new_requests)
    new_requests.each do |request|
      if request.contract.nil?
        RequestMailer.with(request: request).send_contract.deliver_now
        provisional_contract = Contract.new(expiery_date: Date.today + 7, confirmed: false, provisional: true)
        provisional_contract.request = request
        provisional_contract.save
      end
    end
  end

  def self.reassign_que_numbers(requests)
    requests.each_with_index do |request, index|
      request.que_number = index + 1
      request.save
    end
  end
end
