Допустим(/^создадим новое имя с полями:$/) do |table|
   find_or_create Name, table.rows_hash
end

Допустим(/^есть русское имя (.*)$/) do |name|
   find_or_create Name, { text: name }, language_code: :ру
end

Допустим(/^имя (.*) относится к памяти "(.*)"$/) do |nametext, short_name|
   memory = Memory.where( short_name: short_name ).first
   name = Name.where( text: nametext ).first
   if !memory.names.include? name
      memory.names << name
   end
end

То(/^русское имя (.*) будет существовать$/) do |name|
   it = Name.where( text: name ).first
   expect( it ).to be_persisted
end

То(/^многосвязное свойство "(.*)" имени "(.*)" действенно$/) do |attr, nametext|
   name = Name.where( text: nametext ).first
   expect( name ).to have_and_belong_to_many( attr.to_sym )
end

То(/^свойство '(.*)' имени "(.*)" является перечислителем$/) do |attr, nametext|
   name = Name.where( text: nametext ).first
   expect( name ).to define_enum_for( attr.to_sym )
end

То(/^свойства '(.*)' имени "(.*)" не могут быть пустыми$/) do |attrs, nametext|
   name = Name.where( text: nametext ).first
   attrs.split( /,\s*/ ).each do |attr|
      expect( name ).to validate_presence_of( attr.to_sym )
   end
end

