class Contract < ApplicationRecord
  belongs_to :request
  validates :request_id, uniqueness: true

  def expire!
    self.expired = true
  end

  def provisional?
    self.provisional
  end

  def confirm!
    self.confirmed = true
  end

  def renew_expiery_date!
    self.expiery_date = self.expiery_date.next_month
    self.provisional = false
  end

  def unconfirm!
    self.confirmed = false
  end

  def self.expires_next_week
    next_week = Date.today + 7
    Contract.where(expiery_date: next_week, provisional: false, confirmed: true)
  end

  def self.valid_contracts
    Contract.where(provisional: false)
  end

  def self.today_expires_and_unconfirmed
    Contract.where(expiery_date: Date.today, confirmed: false, expired: false)
  end
end
