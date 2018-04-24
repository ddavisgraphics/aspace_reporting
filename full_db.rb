#!/usr/bin/env ruby

# gems 
require 'mysql2'
require 'rubyXL'

# require lib folder
Dir['./lib/*.rb'].each {|file| require file }

# set the root as a constant global
root = File.dirname(__FILE__)

# grabs the sql file you want to get form the database to put into the excel file
tables_file = "#{root}/sql/table_names.txt"
tables_list = File.open(tables_file, 'r') { |f| f.read }
tables_list = tables_list.split(',')
tables_list.map! { |table| table.strip! }

# connect to db 
@db = Database.new

# create a base report to work in
report = RubyXL::Workbook.new
report.write "#{root}/exports/all_data.xlsx"
page_number = 0
total_pages = tables_list.size

tables_list.each do |table|
  # create worksheets
  if page_number.zero?
    worksheet = report[0]
    worksheet.sheet_name = table
  else
    worksheet = report.add_worksheet(table)
  end
  
  # sql calls
  sql = "SELECT * FROM `#{table}`;"
  sql_data = @db.query(sql).to_a

  next if sql_data.empty?

  # write the data to the worksheet
  sql_data.each_with_index do |row_data, row_number|
    worksheet.change_row_height(row_number, 30)
    worksheet.change_row_fill(row_number, 'eeeeee') if row_number.even?
    row_data.values.each_with_index do |cell_data, cell_number|
      worksheet.insert_cell(row_number, cell_number, cell_data)
    end
  end

  # creat the headers
  worksheet.insert_row(0)
  worksheet.change_row_height(0, 30)

  # headers
  headers = sql_data.first.keys
  headers.each_with_index do |value, col_number|
    worksheet.insert_cell(0, col_number, value).change_font_color('ffffff')
    worksheet.change_row_fill(0, '333333')
  end

  # set the number of pages at the end
  page_number += 1

  puts "Created the #{table} section and page count is now #{page_number}/#{total_pages}."
end

report.write "#{root}/exports/all_data.xlsx"
puts "Everything worked congrats!"


