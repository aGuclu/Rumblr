require "sinatra/activerecord"
require 'sinatra'

enable :sessions

if ENV['RACK_ENV'] == 'development'
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
else
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
end

class User < ActiveRecord::Base

end

class Post < ActiveRecord::Base

end

get '/' do
    p session
    erb :home
end

get '/users/signup' do
    erb :'/users/signup'
end

post '/users/signup' do
    @user = User.new(name: params['name'], email: params['email'], password: params['password'], bday: params['bday'])
    @user.save
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
end

get '/users/:id' do
    @user = User.find(params['id'])
    erb :'/users/profile'
end

get '/login' do
   erb :'/users/login'
end

post '/login' do
    user = User.find_by(email: params['email'])
    if user != nil
        if user.password == params['password']
            session[:user_id] = user.id
            redirect "/users/#{user.id}"
        end
    end
end

post '/logout' do
  session['user_id'] = nil
  redirect '/'
end

get '/posts/new' do
    if session['user_id'] == nil
        p 'Log in to post'
        redirect '/login'
    end
    erb :'/posts/new'
end
#
get '/posts/:id' do
    @post = Post.find(params['id'])
    erb :'/posts/view'
end

post '/posts/new' do
    p "posted!"
    @author = User.find_by(email: params['email'])
    @post = Post.new(title: params['title'], content: params['content'], user_id: session['user_id'])
    @post.save
    redirect "/posts/#{@post.id}"
end



# post 'posts/new' do
#   @filename = params[:file][:filename]
#   file = params[:file][:tempfile]
#     File.open("./public/#{@filename}", 'wb') do |f|
#       f.write(file.read)
#     end
#   erb :'posts/view'
# end

# create_table :users do |t|
#   t.string :name
#   t.string :email
#   t.string :password
#   t.date :bday
# end

# create_table :posts do |t|
#   t.string :title
#   t.string :content
#   t.integer :user_id
# end
