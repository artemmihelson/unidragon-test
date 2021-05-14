require 'json'
require 'firebase'
require 'uri/http'

class UsersController < ApplicationController
  key_json_string = File.open('config/firebase/firebase-service.json').read
  FIREBASE = Firebase::Client.new('https://unidragon-test-default-rtdb.firebaseio.com/', key_json_string)

=begin
@api {get} /ping Ping for monitoring
@apiVersion 0.0.1
@apiName Ping
@apiGroup Ping

@apiSuccessExample {json} Response:
{ "status": "pong" }
200 OK
=end
  def ping
    render :json => { :status => 'pong' }
  end

  def save
    if check_if_user_exists(user_params[:email])
      render :json => user_params, status: :ok
    else
      uri = URI.parse(user_params[:order_status_url])
      domain = PublicSuffix.parse(uri.host)
      domain_zone = domain.domain.to_s.split('.').last
      case domain_zone
      when "eu"
        zone = domain_zone
      else
        zone = 'com'
      end
      response = UsersController::FIREBASE.push("users", {
          name: user_params[:name],
          email: user_params[:email],
          created: Time.now.strftime("%d-%m-%Y"),
          zone: zone,
          sent_mail_count: 0
      }
      )
      if response.success?
        render :json => user_params, status: :ok
      else
        render :json => {:error => 'Something wrong'}, status: :bad_request
      end
    end
  end

  def check_and_send_email
    users = get_users_for_date
    users.each do |user_id, user|
      email = user["email"]
      p email
      zone = user["zone"].nil? ? "com" : user["zone"]
      survey_link = zone == "eu" ? "https://unidragon.typeform.com/to/iYjZSDfy" : "https://unidragon.typeform.com/to/NEZIr0Jf"
      UserMailer.with(email: email, survey_url: survey_link).survey_email.deliver_now
    end
    render :json => {:success => true }, status: :ok
  end
  private

  def user_params
    params.permit :email, :name, :order_status_url
  end

  def check_if_user_exists(email)
    response = FIREBASE.get('users', {:orderBy => '"email"', :equalTo => "\"#{email}\""})
    !response.body.blank?
  end

  def get_users_for_date
    date = Time.now.strftime("%d-%m-%Y")
    response = FIREBASE.get('users', {:orderBy => '"created"', :startAt => "\"#{date}\"", :endAt => "\"#{date}\""})
    response.body
  end
end