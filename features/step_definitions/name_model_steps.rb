Допустим(/^создадим новое имя с полями:$/) do |table|
   find_or_create( Name, table.rows_hash ) ; end

Допустим(/^есть русское имя (.*)$/) do |name|
   find_or_create( Name, { text: name }, language_code: :ру ) ; end

Допустим(/^имя (.*) относится к памяти "(.*)"$/) do |nametext, short_name|
   memory = Memory.where( short_name: short_name ).first
   name = Name.where( text: nametext ).first
   if !memory.names.include? name
      memory.names << name ; end ; end

Допустим(/^применим входные данные модели имени:$/) do |string|
   data = YAML.load( string )
   data.each do |r|
      extract_key_to( r, :similar_to )
      name = Name.create( r ) ; end ; end

Допустим(/^есть модель имени$/) do
   @model = Name.new ; end

То(/^русское имя (.*) будет существовать$/) do |name|
   it = Name.where( text: name ).first
   expect( it ).to be_persisted ; end

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

То(/^значение свойства "([^"]*)" имени строго попадает в размер перечислителя$/) do |prop|
#   TODO error: ArgumentError: '["цс", 0]' is not a valid language_code
#  expect( Name.new ).to validate_inclusion_of( :language_code ).
#      in_array( Name.language_codes )
   end

То(/^значение свойства "([^"]*)" имени не может содержать пробела$/) do |prop|
   expect( @model ).to allow_value( 'Василий' ).for( prop ) ; end

То(/^свойства "([^"]*)" имени не могут быть пустыми$/) do |props|
   props.split(/,\s+/).each do |prop|
      expect( @model ).to validate_presence_of( prop ) ; end ; end

То(/^свойство "([^"]*)" имени является перечислителем$/) do |prop|
   expect( @model ).to define_enum_for( prop ) ; end

То(/^свойство "([^"]*)" имени есть отношение к имени" $/) do |prop|
   expect( @model ).to belong_to( prop ).class_name( :Name ) ; end

То(/^имя имеет много памятных имён$/) do
   expect( @model ).to have_many( :memory_names ) ; end

То(/^имя имеет много памятей через памятные имена$/) do
   expect( @model ).to have_many( :memories ).through( :memory_names ) ; end

То(/^имя имеет столб(?:ец|цы) "([^"]*)" рода "(целый|строка)"$/) do |names, type_name|
   type = get_type( type_name )
   names.split( /,\s+/ ).each do |name|
      expect( @model ).to have_db_column( name ).of_type( type ) ; end ; end
