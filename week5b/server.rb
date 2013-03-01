require 'sinatra'
require 'json'
require 'pry'
require_relative 'config'

before  do
  unless request.path_info == '/login' or session[:logged_in] == "yes"
    redirect '/login'
  end 
end

post '/login' do
  if params[:user] == "admin" and params[:password] == "admin"
    session[:logged_in] = "yes"
    session[:user] = params[:user]
    redirect '/'
  end  
end

get '/' do
  disk.merge(mem).to_json
end

get '/login' do
  if session[:logged_in] == "yes"
    erb :logged, :locals => {:user => session[:user]}
  else
    erb :login, :locals => {:user => session[:user]}
  end
end

get '/logout' do
  session[:logged_in] = nil
  redirect '/login'
end

get '/disk/?:id?' do
  disk.to_json
end

get '/memory/?:id?' do
  mem.to_json
end

get '/help' do 
  erb :help
end

def mem
  {memory: get_line(transpose(`free -m`.split("\n")))}
end

def disk
  {disk: get_line(transpose(`df -h`.split("\n")))}
end



private
def transpose(lines)
  result = []  
  max_words = lines.max_by {|line| line.split.size}.split.size
  max_words.times {result << []}
  max_words.times do |index| 
    lines.map.with_index do |line, line_number|
      words = line.split
      # print words, index, line_number, "\n" 
      result[index] << words[index]     
    end
  end
  result.map{|line| line.join(" ")}    
end

def get_line(arr)
  if params[:id].nil?
    arr    
  else
    arr[params[:id].to_i] || "ERROR"
  end   
end