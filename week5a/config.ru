# encoding: utf-8
=begin
  Задача:
  GET / - выводить размер занятой памяти и жёсткого диска
  GET /memory - выводить память
  GET /disc - размер диска
  GET /help - страничку о доступных путях
=end
require 'rack'
require 'pry'

class SimpleUtil
  ROUTES = {
    '/' => Proc.new {mem + "<br>" + disc },
    '/memory' => Proc.new {mem},
    '/disc' => Proc.new {disc},
    '/help' => Proc.new do [
      "GET / - выводить размер занятой памяти и жёсткого диска",
      "GET /memory - выводить память ", 
      "GET /disc - размер диска", 
      "GET /help - страничку о доступных путях"
      ].join("<br>")  
    end
  }

  def call(env)
    @request  = Rack::Request.new(env)
    @response = Rack::Response.new
    @response.status = 200
    @response['Content-Type'] = 'text/html;charset=utf-8'
    @response.body = [ handle(@request.env["REQUEST_URI"]) ]
    @response.finish
  end

  def handle(location)
    if ROUTES.has_key? location 
      responce_text = ROUTES[location].call 
    else
     @response.status = 404
     responce_text = 'У нас обед, приходите позже. 404'
    end
    "<pre>" + responce_text + "</pre>" 
  end

  def self.mem
    `free -m`
  end
  def self.disc
    `df -h`
  end
end

run SimpleUtil.new