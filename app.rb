# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require './db/database'
require 'sinatra/base'

get '/' do
  @title = 'top'
  @memos = Data.all
  erb :top
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  @title = 'show'
  @memo = Data.find_memo(h(params[:id]).to_s)
  erb :show
end

get '/memos/:id/edit' do
  @title = 'edit'
  @memo = {}
  @memo = Data.find_memo(h(params[:id]).to_s)
  erb :edit
end

post '/memos' do
  id_max = Data.read_idmax.to_i
  id_max += 1
  memos = Data.all
  memos << { 'id' => id_max.to_s, 'title' => h(params[:title]).to_s, 'content' => h(params[:content]).to_s }
  Data.print_memos(memos)
  Data.print_idmax(id_max.to_s)
  redirect to('/')
end

patch '/memos/:id' do
  p params[:id]

  Data.update_memo(h(params[:id]).to_s, h(params[:title]).to_s, h(params[:content]).to_s)
  redirect to('/')
end

delete '/memos/:id' do
  Data.delete_memo(h(params[:id]).to_s)
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
