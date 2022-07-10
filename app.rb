# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

$memos_file = 'json/memos.json'

$memos = File.open($memos_file) do |memo|
  JSON.load(memo)
end

$id_max = 0

get '/' do
  @title = 'top'
  erb :top
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  @title = 'show'
  @memo = {}
  $memos.each do |memo|
    @memo = memo if memo['id'] == h(params[:id]).to_s
  end
  erb :show
end

get '/memos/:id/edit' do
  @title = 'edit'
  @memo = {}
  $memos.each do |memo|
    @memo = memo if memo['id'] == h(params[:id]).to_s
  end
  erb :edit
end

post '/memos/create' do
  $id_max = $id_max + 1
  $memos << { 'id' => $id_max.to_s, 'title' => h(params[:title]).to_s, 'content' => h(params[:content]).to_s }
  File.open($memos_file, 'w') do |file|
    JSON.dump($memos, file)
  end
  redirect to('/')
end

patch '/memos/:id' do
  index = -1
  $memos.each_with_index do |memo, i|
    index = i if memo['id'] == h(params[:id]).to_s
  end

  $memos[index] = { 'id' => h(params[:id]).to_s, 'title' => h(params[:title]).to_s, 'content' => h(params[:content]).to_s }

  File.open($memos_file, 'w') do |file|
    JSON.dump($memos, file)
  end
  redirect to('/')
end

delete '/memos/:id' do
  index = -1
  $memos.each_with_index do |memo, i|
    index = i if memo['id'] == h(params[:id]).to_s
  end

  $memos.delete_at(index)

  File.open($memos_file, 'w') do |file|
    JSON.dump($memos, file)
  end
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
