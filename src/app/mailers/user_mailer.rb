class UserMailer < ApplicationMailer
  default from: 'mail@m.unidragon.com'

  def survey_email
    @url  = params[:survey_url]
    mail(to: params[:email], subject: 'We set a course for feedback - leave yours')
  end
end
