require 'sinatra'
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
    erb :signup, :locals => {:flash => user.errors.to_a.join(',')}
  end
  
end

post '/login' do
  user_to_check = User.first_or_create(:name => params[:user])
  found = !user_to_check.nil?
  if found and params[:password] == user_to_check.password
    authentificate(user_to_check)
    redirect '/'
  else
    binding.pry
    erb :login, :locals => {:flash => found ? "Wrong pass, try again" : "No such user", :user => user_to_check.name}
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
    erb :login, :locals => {:user => user, :flash => 'Greetings'}
  end
end

get '/signup/?' do
  erb :signup, :locals => {:flash => 'Greetings'}
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