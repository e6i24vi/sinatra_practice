# frozen_string_literal: true

require 'json'
class Data
  def self.all
    JSON.parse(File.read(File.expand_path('json/memos.json', __dir__), symbolize_names: true))
  end

  def self.print_memos(memos)
    File.open(File.expand_path('json/memos.json', __dir__), 'w') do |file|
      JSON.dump(memos, file)
    end
  end

  def self.find_memo(id)
    memos = Data.all
    memo_ret = {}
    memos.each do |memo|
      memo_ret = memo if memo['id'] == id
    end
    memo_ret
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
