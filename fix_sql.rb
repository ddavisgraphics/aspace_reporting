#!/usr/bin/env ruby

# gems 
require 'mysql2'
require 'rubyXL'

# require lib folder
Dir['./lib/*.rb'].each {|file| require file }

# set the root as a constant global
root = File.dirname(__FILE__)

# grabs the sql file you want to get form the database to put into the excel file
sql_file = FileHelper.new("#{root}/sql/note.sql")
sql = sql_file.get_file_contents.to_s

# connect to db
@db = Database.new
sql_data = @db.query(sql).to_a

# regex
regex = /(\\n|\n){2,}/m

sql_data.each do |row|
  id = @db.escape(row[:id])
  notes = @db.escape(row[:notes].gsub(regex, '\n'))
  sql_update = "UPDATE note SET notes='#{notes}' WHERE id='#{id}'"
  update = @db.query(sql_update)
  puts update.inspect
end

# sql_data = @db.query(sql).to_a
# puts sql_data[0][:notes]