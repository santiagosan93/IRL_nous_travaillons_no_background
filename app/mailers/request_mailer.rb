class RequestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.request_mailer.confirmation.subject
  #
  def confirmation
    @request = params[:request] # Instance variable => available in view
    mail(to: @request.email, subject: 'Nous Travaillons - request confirmation')
  end

  def send_contract
    @request = params[:request] # Instance variable => available in view
    mail(to: @request.email, subject: 'Nous Travaillons - We have a spot for you!')
  end

  def request_renewal_confirmation
    @request = params[:request] # Instance variable => available in view
    mail(to: @request.email, subject: 'Nous Travaillons - request renewal')
  end
end
