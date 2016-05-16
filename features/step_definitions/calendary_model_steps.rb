Допустим(/^есть календарь "([^"]*)"$/) do |slug|
   create( :calendary, slug: slug ) ; end

Допустим(/^попробуем создать календарь "([^"]*)" без описания$/) do |slug|
   sample { create( :calendary, slug: slug, descriptions: false,
      names: false ) } ; end

Если(/^попробуем создать новый календарь "([^"]*)" с неверным описанием$/) do |arg1|
   sample { create :calendary, :with_invalid_description } ; end

То(/^у модели суть действенными многоимущие свойства:$/) do |table|
   table.hashes.each do |hash|
      expect( subject ).to have_many( hash[ "свойства" ] )
         .class_name( model_of( hash[ "имя рода" ] ) )
         .dependent( hash[ "зависимость" ] ) ;end;end
