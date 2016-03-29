Допустим(/^есть памятное имя (.*) относящееся к памяти "([^"]*)"$/) do |nametext, short_name|
   memory = Memory.where( short_name: short_name ).first
   name = Name.where( text: nametext ).first
   find_or_create MemoryName, name: name, memory: memory ;end

То(/^свойства '(.*)' памятного имени "([^"]*)" являются отношением$/) do |attrs, nametext|
   memory_name = MemoryName.where( name: Name.where( text: nametext ).first ).first
   attrs.split( /,\s*/ ).each do |attr|
      expect( memory_name ).to belong_to( attr.to_sym ) ;end ;end

То(/^свойства '(.*)' памятного имени "([^"]*)" не могут быть пустыми$/) do |attrs, nametext|
   memory_name = MemoryName.where( name: Name.where( text: nametext ).first ).first
   attrs.split( /,\s*/ ).each do |attr|
      expect( memory_name ).to validate_presence_of( attr.to_sym ) ;end ;end

То(/^свойство '(.*)' памятного имени "([^"]*)" является перечислителем$/) do |attr, nametext|
   memory_name = MemoryName.where( name: Name.where( text: nametext ).first ).first
   expect( memory_name ).to define_enum_for( attr.to_sym ) ;end

