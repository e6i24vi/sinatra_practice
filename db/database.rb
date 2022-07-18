# frozen_string_literal: true

require 'json'
class Data
  def self.all
    memos = JSON.parse(File.read(File.expand_path('json/memos.json', __dir__), symbolize_names: true))
    id_max = 0

    memos.each do |memo|
      id_max = (memo['id'].to_i > id_max ? memo['id'].to_i : id_max)
    end
    File.open(File.expand_path('index.txt', __dir__), 'w') do |file|
      file.write(id_max.to_s)
    end
    memos
  end

  def self.read_idmax
    id_max = 0
    File.open(File.expand_path('index.txt', __dir__), 'r') do |file|
      id_max = file.read.to_i
    end
    id_max
  end

  def self.print_idmax(id_max)
    File.open(File.expand_path('index.txt', __dir__), 'w') do |file|
      file.write(id_max.to_s)
    end
  end

  def self.print_memos(memos)
    File.open(File.expand_path('json/memos.json', __dir__), 'w') do |file|
      JSON.dump(memos, file)
    end
  end

  def self.find_memo(id)
    memos = Data.all
    @memo_ret = {}
    memos.each do |memo|
      @memo_ret = memo if memo['id'] == id
    end
    @memo_ret
  end

  def self.update_memo(id, title, content)
    index = -1
    memos = Data.all
    memos.each_with_index do |memo, i|
      index = i if memo['id'] == id
    end
    memos[index] = { 'id' => id, 'title' => title, 'content' => content }
    File.open(File.expand_path('json/memos.json', __dir__), 'w') do |file|
      JSON.dump(memos, file)
    end
  end

  def self.delete_memo(id)
    index = -1
    memos = Data.all
    memos.each_with_index do |memo, i|
      index = i if memo['id'] == id
    end

    memos.delete_at(index)

    File.open(File.expand_path('json/memos.json', __dir__), 'w') do |file|
      JSON.dump(memos, file)
    end
  end
end
