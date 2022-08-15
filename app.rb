# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/base'

require 'pg'

require_relative './db/memodb'

memosdb = MemosDB.new

get '/' do
  @title = 'top'
  @memos = memosdb.all_memos
  erb :top
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  @title = 'show'
  @memo = memosdb.find_memo(params)
  erb :show
end

get '/memos/:id/edit' do
  @title = 'edit'
  @memo = memosdb.find_memo(params)
  erb :edit
end

post '/memos' do
  memo = { title: params['title'], content: params['content'] }
  memosdb.insert_memos(memo)
  redirect to('/')
end

patch '/memos/:id' do
  memosdb.update_memo(params)
  redirect to('/')
end

delete '/memos/:id' do
  memosdb.delete_memo(params)
  redirect to('/')
end

get '/*' do
  erb :notfound
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
