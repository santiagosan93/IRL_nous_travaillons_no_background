class Request < ApplicationRecord
  after_create :send_confirmation_email

  validates :first_name, :last_name, :email, :bio, :phone_number, presence: true
  validates :email, uniqueness: true
  validates :phone_number, format: { with: /^((\+)33|0)[1-9](\d{2}){4}$/,
    message: "- Make sure you're typing in a french number", multiline: true }
  validates :email, format: { with: /([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/,
    message: "- You've entered an invalid email"}

  has_one :contract

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

  def accept!
    self.confirmed = true
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

  private

  def send_confirmation_email
    RequestMailer.with(request: self).confirmation.deliver_now
  end
end
