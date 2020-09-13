class ContractMailer < ApplicationMailer
  before_action :set_contract_and_request

  def contract_renewal_confirmation
    mail(to:@request.email, subject: 'Nous Travaillons - contract renewal')
  end

  def contract_expired
    mail(to:@request.email, subject: 'Nous Travaillons - contract cancelation')
  end

  private

  def set_contract_and_request
    @contract = params[:contract]
    @request = @contract.request
  end
end
