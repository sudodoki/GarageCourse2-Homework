require 'sinatra'
require 'rack-flash'
require 'json'
require 'pry'
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'  
require 'dm-validations'  
require 'dm-sqlite-adapter'
require_relative 'config'
require_relative 'database_stuff'

ALLOWED_ROUTES = ['/login', '/signup']
before  do
  unless ALLOWED_ROUTES.include? request.path_info or session[:logged_in] == "yes"
    redirect '/login'
  end 
end

post '/signup' do
  user = User.create(:name => params[:user], :password => params[:password], :password_confirmation => params[:password_confirmation])
  if user.save
    authentificate(user)
    redirect '/'
  else
    flash[:error] = user.errors.to_a.join(',')
    erb :signup
  end
  
end

post '/login' do
  user_to_check = User.first(:name => params[:user])
  found = !user_to_check.nil?
  binding.pry
  if found and params[:password] == user_to_check.password
    authentificate(user_to_check)
    redirect '/'
  else
    flash[:error] = found ? "Wrong pass, try again" : "No such user"
    erb :login, :locals => {:user => user_to_check.nil? ? '' : user_to_check.name}
  end  
end

get '/?' do
  "MAIN PAGE. IF YOU SEE THIS YOU'VE GOT VERY SHARP VISION AND SIGNED IN"
end

get '/login/?' do
  user = session[:user]
  if session[:logged_in] == "yes"
    redirect "/users/#{user}"
  else
    erb :login, :locals => {:user => user}
  end
end

get '/signup/?' do
  erb :signup
end

get '/logout' do
  session[:logged_in] = nil
  redirect '/login'
end

get '/users/?:name?' do
  to_show = params[:name] ? [User.first(name: params[:name])] : User.all
  to_show = to_show.map {|user| "#{user.name} #{user.try(:ip)} #{user.try(:updated_at)}"}
  User.count == 0 ? 'NO USERS MAN' : "USER(S):\n" + to_show.join(',')
end

def authentificate(user)
  session[:logged_in] = "yes"
  session[:user] = user.name
  user.update(:ip => request.ip) 
  user.save
end