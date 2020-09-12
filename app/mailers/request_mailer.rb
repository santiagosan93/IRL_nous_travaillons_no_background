class RequestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.request_mailer.confirmation.subject
  #
  def confirmation
    @request = params[:request] # Instance variable => available in view
    mail(to: @request.email, subject: 'Nous Travaillons request confirmation')
  end
end
