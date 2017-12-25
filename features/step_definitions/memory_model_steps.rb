Допустим(/^есть чин "([^"]*)"$/) do |order|
   create( :order, order: order ) ; end

Допустим(/^есть память "(.*)"$/) do |short_name|
   create( :memory, short_name: short_name ) ; end

Допустим(/^суть памяти "([^"]*)"$/) do |names|
   names.split(/\s*,\s*/).each do |short_name|
      create( :memory, short_name: short_name ) ; end ; end

То(/^свойство '(.*)' памяти "([^"]*)" не может быть пустым$/) do |attr, short_name|
   name = Memory.where( short_name: short_name ).first
   expect( name ).to validate_presence_of( attr.to_sym ) ; end

То(/^выборка "([^"]*)" памяти выбирает поля "([^"]*)"$/) do |scope, field|
   record = Memory.last
   subject = Memory.send( scope, record.send( field ) )
   expect( subject ).to match_array( [ record ] ) ; end

То(/^у памяти "([^"]*)" суть действенными многоимущие свойства:$/) do |short_name, table|
   memory = Memory.where( short_name: short_name ).first
   table.rows.flatten.each do |attr|
      expect( memory ).to have_many( attr.to_sym ) ; end ; end
