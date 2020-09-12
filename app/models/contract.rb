class Contract < ApplicationRecord
  belongs_to :request
  validates :request_id, uniqueness: true
end
