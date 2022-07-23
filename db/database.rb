# frozen_string_literal: true

require 'pg'

class Data
  def self.all
    memos = []
    begin
      connection = PG.connect(host: 'localhost', port: 5432, dbname: 'memo')
      connection.exec('CREATE TABLE IF NOT EXISTS memos (id serial PRIMARY KEY,title varchar(40),content text) ')
      dbmemos = connection.exec('SELECT * from memos')
      dbmemos.each do |row|
        memos << { id: row['id'].to_s, title: row['title'], content: row['content'] }
      end
    rescue PG::Error => e
      puts e.message
    ensure
      connection&.close
    end
    memos
  end

  def self.insert_memos(memo)
    connection = PG.connect(host: 'localhost', port: 5432, dbname: 'memo')
    connection.exec("INSERT INTO memos (title,content) VALUES ( '#{memo['title']}', '#{memo['content']}')")
  rescue PG::Error => e
    puts e.message
  ensure
    connection&.close
  end

  def self.find_memo(id)
    memo_ret = {}
    begin
      connection = PG.connect(host: 'localhost', port: 5432, dbname: 'memo')
      dbmemos = connection.exec("SELECT id,title, content FROM memos WHERE id = #{id.to_i}")
      dbmemos.each do |row|
        memo_ret = { id: row['id'].to_s, title: row['title'], content: row['content'] }
      end
    rescue PG::Error => e
      puts e.message
    ensure
      connection&.close
    end
    memo_ret
  end

  def self.update_memo(id, title, content)
    connection = PG.connect(host: 'localhost', port: 5432, dbname: 'memo')
    connection.exec("UPDATE memos SET title = '#{title}' ,content='#{content}' WHERE id = #{id.to_i};")
  rescue PG::Error => e
    puts e.message
  ensure
    connection&.close
  end

  def self.delete_memo(id)
    connection = PG.connect(host: 'localhost', port: 5432, dbname: 'memo')
    connection.exec("DELETE from memos WHERE id = #{id.to_i};")
  rescue PG::Error => e
    puts e.message
  ensure
    connection&.close
  end
end
