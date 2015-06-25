Допустим(/^создадим новую память с полями:$/) do |table|
   find_or_create Memory, table.rows_hash
end

Допустим(/^есть память "(.*)"$/) do |short_name|
   find_or_create Memory, short_name: short_name
end

То(/^многосвязное свойство "(.*)" памяти "(.*)" действенно$/) do |attr, short_name|
   memory = Memory.where( short_name: short_name ).first
   expect( memory ).to have_and_belong_to_many( attr.to_sym )
end

То(/^память "([^"]*)" будет существовать$/) do |short_name|
   it = Memory.where( short_name: short_name ).first
   expect( it ).to be_persisted
end

То(/^свойство '(.*)' памяти "([^"]*)" не может быть пустым$/) do |attr, short_name|
   name = Memory.where( short_name: short_name ).first
   expect( name ).to validate_presence_of( attr.to_sym )
end

