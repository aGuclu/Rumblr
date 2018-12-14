require "sinatra/activerecord"
require 'sinatra'

enable :sessions

if ENV['RACK_ENV']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end

class User < ActiveRecord::Base

end

class Post < ActiveRecord::Base

end

get '/' do
    erb :home
end

get '/login' do
   erb :'/users/login'
end

post '/login' do
    user = User.find_by(email: params['email'])
    if user != nil
        if user.password == params['password']
            session[:user_id] = user.id
            sleep 1
            redirect "/users/#{user.id}"
        end
    end
end

post '/logout' do
  session['user_id'] = nil
  redirect '/'
end

get '/users/signup' do
  if session['user_id'] != nil
      p 'User was already logged in'
      redirect '/'
  end
  erb :'/users/signup'
end

post '/users/signup' do
    @user = User.new(name: params['name'], email: params['email'], password: params['password'], bday: params['bday'])
    @user.save
    session[:user_id] = @user.id
    sleep 1
    redirect "/users/#{@user.id}"
end

get '/users/:id' do
    @user = User.find(session['user_id'])
    @posts = Post.where(user_id: session['user_id'])
    erb :'/users/profile'
end

get '/posts/new' do
    if session['user_id'] == nil
        p 'Log in to post'
        redirect '/login'
    end
    erb :'/posts/new'
end

get '/posts/:id' do
    @post = Post.find(params['id'])
    erb :'/posts/view'
end

post '/posts/new' do
    p "posted!"
    @post = Post.new(title: params['title'], imageURL: params['imageURL'], user_id: session['user_id'])
    @post.save
    redirect "/posts/#{@post.id}"
end

get '/posts/?' do
    @posts = Post.all.reverse
    erb :'/posts/all'
end

post '/delete_post/:id' do
    @post = Post.find(params[:id]).delete
    redirect'/'
end

post '/deleteUser' do
  @user = User.find(session['user_id'])
  if @user != nil
      @user.destroy
      @user.save
      session['user_id'] = nil
      redirect '/'
      erb :'users/myaccount'
  end
end

# post '/save' do
#   @post = Post.new(title: params['title'], image: params[:file][:filename], user_id: session['user_id'])
#   @post.save
#   file = params[:file][:tempfile]
#   File.open("./public/#{@post.image}", 'wb') do |f|
#     f.write(file.read)
#   end
#   @posts = Post.all
#   erb :'/posts/all'
# end
