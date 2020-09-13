class RequestsController < ApplicationController
  before_action :set_request, only: [:ask_for_confirmation, :email_confirmation]

  def create
    @request = Request.new(request_params)
    @request.remove_spaces_of_phone_number
    if @request.save
      redirect_to ask_for_confirmation_request_path(@request)
    else
      @errors = @request.errors.full_messages
      render "pages/home"
    end
  end

  def ask_for_confirmation
  end

  def email_confirmation
    @request.confirm!
    @is_old_request = @request.has_que_number
    @request.assign_que_number unless @request.has_que_number
    @request.renew_expiery_date
    @request.save
  end

  def request_renewall_confirmation
    @request.confirm!
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:first_name, :last_name, :email, :bio, :phone_number)
  end
end
