require 'sinatra'
require 'sinatra/activerecord'

enable :sessions

if ENV['RACK_ENV']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
end

class Post < ActiveRecord::Base
  belongs_to :user
end

# before ['/post', '/posts', '/posts/:id', '/profile/?'] do
#   if session['user_id'] == nil
#     redirect '/'
#   end
# end

get '/' do
  erb :home
end

get '/login' do
  erb :'/users/login'
end

post '/login' do
  @user = User.find_by(email: params[:email])
    if @user.password == params[:password]
      session['user_id'] = @user.id
      sleep 1
      redirect '/users/#{@user.id}'
    else
      redirect '/login'
    end
  erb :'/users/login'
end

post '/logout' do
  session['user_id'] = nil
  redirect '/'
end

get '/signup' do
  if session['user_id'] != nil
    redirect '/'
  end
  erb :'/users/signup'
end

post '/signup' do
  @user = User.new(name: params[:name], email: params[:email], password: params[:password], bday: params[:bday])
  @user.save
  session['user_id'] = @user.id
  sleep 1
  redirect '/users/#{@user.id}'
  erb :'/users/signup'
end

get '/users/:id' do
  @user = User.find(params[:id])
  erb :'/users/profile'
end

post '/users/:id' do
  user = User.find(session[:user_id])
  if user != nil
    posts = Post.where(user_id: user.id)
    posts.each do |post|
      post.destroy
    end
    user.destroy
    user.save
    session['user_id'] = nil
    redirect '/'
  end
end

get '/posts/new' do
  if session['user_id'] == nil
      p 'Log in to post'
      redirect '/'
  end
  erb :'/posts/new'
end

post '/posts/new' do
  @post = Post.new(user_id: session['user_id'], title: params[:title], content: params[:content])
  @post.save
  redirect '/posts/all'
end

get '/posts/?' do
  @posts = Post.all.reverse
  erb :'/posts/all'
end

post '/posts/:id' do
  @post = Post.find(params[:id])
  @post.destroy
  redirect '/users/#{session[:user_id]}'
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
