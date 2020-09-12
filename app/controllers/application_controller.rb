class ApplicationController < ActionController::Base
  before_action :set_max_capacity

  private

  def set_max_capacity
    @max_capacity = 20
  end
end
