Допустим(/^есть модель ссылки$/) do
   @model = Link.new ; end

Допустим(/^создадим новую ссылку с полями:$/) do |table|
   find_or_create( Link, table.rows_hash ) ; end

То(/^ссылка на русский ресурс "([^"]*)" будет существовать$/) do |url|
   it = Link.where( url: url ).first
   expect( it ).to be_persisted ; end
