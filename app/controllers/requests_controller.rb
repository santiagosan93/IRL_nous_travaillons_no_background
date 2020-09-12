class RequestsController < ApplicationController
  before_action :set_request, only: [:confirmation, :email_confirmation]
  def create
    @request = Request.new(request_params)
    @request.remove_spaces_of_phone_number
    if @request.save
      redirect_to confirmation_request_path(@request)
    else
      @errors = @request.errors.full_messages
      render "pages/home"
    end
  end

  def confirmation
  end

  def email_confirmation
    @request.confirmed = true
    @request.save
  end


  private

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:first_name, :last_name, :email, :bio, :phone_number)
  end
end
