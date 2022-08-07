# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/base'
require 'pg'

before do
  @connection = PG.connect(host: 'localhost', port: 5432, dbname: 'memo')
  @connection.exec('CREATE TABLE IF NOT EXISTS memos (id serial PRIMARY KEY,title varchar(40),content text) ')
end

def all_memos
  query = 'SELECT * from memos'

  dbmemos = @connection.exec(query)
  dbmemos.map do |row|
    { id: row['id'].to_s, title: row['title'], content: row['content'] }
  end
end

def insert_memos(memo)
  query = 'INSERT INTO memos (title,content) VALUES($1,$2)'
  @connection.exec(query, [memo[:title], memo[:content]])
end

def find_memo(params)
  query = 'SELECT id,title, content FROM memos WHERE id = $1'
  dbmemos = @connection.exec(query, [params[:id]])
  dbmemos.first
end

def update_memo(params)
  query = 'UPDATE memos SET title = $2 ,content= $3 WHERE id = $1'
  @connection.exec(query, [params[:id].to_i, params[:title], params[:content]])
end

def delete_memo(params)
  query = 'DELETE from memos WHERE id = $1'
  @connection.exec(query, [params[:id]])
end

get '/' do
  @title = 'top'
  @memos = all_memos
  erb :top
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  @title = 'show'
  @memo = find_memo(params)
  erb :show
end

get '/memos/:id/edit' do
  @title = 'edit'
  @memo = find_memo(params)
  erb :edit
end

post '/memos' do
  memo = { title: params['title'], content: params['content'] }
  insert_memos(memo)
  redirect to('/')
end

patch '/memos/:id' do
  update_memo(params)
  redirect to('/')
end

delete '/memos/:id' do
  delete_memo(params)
  redirect to('/')
end

get '/*' do
  erb :notfound
end
