Допустим(/^создадим новую память с полями:$/) do |table|
   find_or_create( Memory, table.rows_hash ) ; end

Допустим(/^есть память "(.*)"$/) do |short_name|
   find_or_create( Memory, short_name: short_name ) ; end


Допустим(/^суть памяти "([^"]*)"$/) do |names|
   names.split(/\s*,\s*/).each do |short_name|
      find_or_create( Memory, short_name: short_name ) ; end ; end

То(/^многоимущие свойства "(.*)" памяти "(.*)" действенны$/) do |attrs, short_name|
   memory = Memory.where( short_name: short_name ).first
   attrs.split( /,\s*/ ).each do |attr|
      expect( memory ).to have_many( attr.to_sym ) ; end ; end

То(/^память "([^"]*)" будет существовать$/) do |short_name|
   it = Memory.where( short_name: short_name ).first
   expect( it ).to be_persisted ; end

То(/^свойство '(.*)' памяти "([^"]*)" не может быть пустым$/) do |attr, short_name|
   name = Memory.where( short_name: short_name ).first
   expect( name ).to validate_presence_of( attr.to_sym ) ; end

То(/^выборка "([^"]*)" памяти выбирает поля "([^"]*)"$/) do |scope, field|
   record = Memory.last
   subject = Memory.send( scope, record.send( field ) )
   expect( subject ).to match_array( [ record ] ) ; end
