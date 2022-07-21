# encoding: utf-8
# XXX/ Этот код необходим только при использовании руских букв на виндовс

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'rexml/document' # подключаем парсер
require 'date' # будем использовать операции с датами

puts "на что потрачены деньги?"
expense_text = STDIN.gets.chomp

puts "Сколько потратили?"
expense_amount = STDIN.gets.chomp.to_i

puts "Укажите дату траты (ДД.ММ.ГГГГ) по умолчанию сегодня"
date_input = STDIN.gets.chomp
expense_date = nil

if date_input == ""
  expense_date = Date.today
else
  expense_date = Date.parse(date_input)
end

puts "В какую категорию занести трату?"
expense_category = STDIN.gets.chomp

current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"
file = File.new(file_name, "r:UTF-8")

begin
  doc = REXML::Document.new(file)
rescue REXML::ParseException => e
  puts "ошибка файла"
  abort e.message
end

file.close

expenses = doc.elements.find('expense').first

expense = expenses.add_element 'expense', {
  'amount' => expense_amount,
  'category' => expense_category,
  'date' => expense_date.to_s
}

expense.text = expense_text

file = File.new(file_name, "w:UTF-8")
doc.write(file, 2)
file.close
puts "Запись завершена"