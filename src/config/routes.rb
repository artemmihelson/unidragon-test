Rails.application.routes.draw do
  get '/ping', to: 'users#ping'
  post '/save', to: 'users#save'
  get '/send_email', to: 'users#check_and_send_email'
end
