Допустим(/^есть строка имени:$/) do |string|
   @namer = Bukovina::Parsers::Name.new
   @res = @namer.parse( string.strip ) ; end

Допустим(/^есть строки имени:$/) do |string|
   @namer = Bukovina::Parsers::Name.new
   @res = @namer.parse( YAML.load( string ) ) ; end

То(/^обработанные данные имени будут выглядеть как:$/) do |string|
   expect( @res[ :name ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанные данные памятного имени будут выглядеть как:$/) do |string|
   expect( @res[ :memory_name ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанных данных имени не будет$/) do
   expect( @res ).to be_nil ; end

То(/^в списке ошибок будет "([^"]*)"$/) do |text|
   name = Bukovina::Parsers::Name
   types = {
      'ошибка индекса' => name::BukovinaIndexError,
      'ошибка неверного языка' => name::BukovinaInvalidLanguageError,
      'ошибка неверной буквы языка' => name::BukovinaInvalidCharError,
      'ошибка неверного признака' => name::BukovinaInvalidTokenError,
      'ошибка неверного заменятеля' => name::BukovinaInvalidVariatorError,
      'ошибка неверного перечислителя' => name::BukovinaInvalidEnumeratorError,
   }
   expect( @namer.errors ).to match_array( [ types[ text ] ] ) ; end


То(/^значение свойства "([^"]*)" имени строго попадает в размер перечислителя$/) do |prop|
#   expect( Name.first ).to validate_inclusion_of( :language_code ).
#      in_array(Name.language_codes)
end

То(/^значение свойства "([^"]*)" имени не может содержать пробела$/) do |prop|
   expect( Name.first ).to allow_value('Василий').for(:text)
end

То(/^свойства "([^"]*)" имени "([^"]*)" не могут быть пустыми$/) do |props, arg2|
   expect( Name.first ).to validate_presence_of(:language_code)
   expect( Name.first ).to validate_presence_of(:text)
end

То(/^свойство "([^"]*)" имени "([^"]*)" является перечислителем$/) do |arg1, arg2|
   expect( Name ).to define_enum_for(:language_code)
end

Допустим(/^применим входные данные модели имени:$/) do |string|
   data = YAML.load( string )
   data.each do |r|
      similar_to = r.delete( :similar_to )
      if similar_to
         s = similar_to.deep_dup
         s[ :language_code ] =
         Name.language_codes[ similar_to[ :language_code ] ]
         r[ :similar_to ] = Name.where( s ).first ; end
      name = Name.create( r ) ; end ; end

То(/^будут существовать русские имена "([^"]*)"$/) do |names|
   names.split( /,\s+/ ).each do |name|
      expect( Name.where( text: name, language_code: 1 ).first ).to_not be_nil
      end ; end

То(/^будет существовать (сербское|греческое|английское) имя "([^"]*)"$/) do |lang, name|
   lcode = { сербское: 2, греческое: 3, английское: 4 }[ lang.to_sym ]
   expect( Name.where( text: name, language_code: lcode ).first ).to_not be_nil
   end

То(/^свойство "([^"]*)" имени "([^"]*)" будет указывать на имя "([^"]*)"$/) do |prop, name, target_name|
   name_r = Name.where( text: name ).first
   expect( name_r.send( prop ) ).to be_eql( Name.where( text: target_name ).first )
   end

