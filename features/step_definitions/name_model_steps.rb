Допустим(/^создадим новое личное имя с полями:$/) do |table|
   find_or_create( FirstName, table.rows_hash ) ; end

Допустим(/^есть русское личное имя (.*)$/) do |name|
   find_or_create( FirstName, { text: name }, language_code: :ру ) ; end

Допустим(/^имя (.*) относится к памяти "(.*)"$/) do |nametext, short_name|
   memory = Memory.where( short_name: short_name ).first
   name = FirstName.where( text: nametext ).first
   if !memory.names.include? name
      memory.names << name ; end ; end

Допустим(/^применим входные данные модели имени:$/) do |string|
   data = YAML.load( string )
   data.each do |r|
      extract_key_to( r, :similar_to )
      name = FirstName.create( r ) ; end ; end

Допустим(/^есть модель личного имени$/) do
   @model = FirstName.new ; end

Допустим(/^попробуем создать имя с полями:$/) do |table|
   expect{ Name.create( table.rows_hash ) }.to raise_error( NotImplementedError ) ; end

Допустим(/^создадим новое отчество с полями:$/) do |table|
   find_or_create( Patronymic, table.rows_hash ) ; end

Допустим(/^создадим новую фамилию с полями:$/) do |table|
   find_or_create( LastName, table.rows_hash ) ; end

Допустим(/^попробуем создать отчество с полями:$/) do |table|
   @record = Patronymic.create( table.rows_hash ) ; end

Допустим(/^попробуем создать фамилию с полями:$/) do |table|
   @record = LastName.create( table.rows_hash ) ; end

То(/^русское личное имя (.*) будет существовать$/) do |name|
   it = FirstName.where( text: name ).first
   expect( it ).to be_persisted ; end

То(/^будут существовать русские личные имена "([^"]*)"$/) do |names|
   names.split( /,\s+/ ).each do |name|
      expect( FirstName.where( text: name, language_code: 1 ).first ).to_not be_nil
      end ; end

То(/^будет существовать (сербское|греческое|английское) личное имя "([^"]*)"$/) do |lang, name|
   lcode = { сербское: 2, греческое: 3, английское: 4 }[ lang.to_sym ]
   expect( FirstName.where( text: name, language_code: lcode ).first ).to_not be_nil
   end

То(/^свойство "([^"]*)" имени "([^"]*)" будет указывать на личное имя "([^"]*)"$/) do |prop, name, target_name|
   name_r = FirstName.where( text: name ).first
   expect( name_r.send( prop ) ).to be_eql( Name.where( text: target_name ).first )
   end

То(/^значение свойства "([^"]*)" личного имени строго попадает в размер перечислителя$/) do |prop|
#   TODO error: ArgumentError: '["цс", 0]' is not a valid language_code
#   binding.pry
#   expect( FirstName.new ).to validate_inclusion_of( :language_code ).
#      in_array( FirstName.language_codes.keys )
   end

То(/^значение свойства "([^"]*)" личного имени не может содержать пробела$/) do |prop|
   expect( @model ).to allow_value( 'Василий' ).for( prop ) ; end

То(/^свойства "([^"]*)" личного имени не могут быть пустыми$/) do |props|
   props.split(/,\s+/).each do |prop|
      expect( @model ).to validate_presence_of( prop ) ; end ; end

То(/^свойство "([^"]*)" личного имени является перечислителем$/) do |prop|
   expect( @model ).to define_enum_for( prop ) ; end

То(/^свойство "([^"]*)" личного имени есть отношение к имени" $/) do |prop|
   expect( @model ).to belong_to( prop ).class_name( :Name ) ; end

То(/^личное имя имеет много памятных имён$/) do
   expect( @model ).to have_many( :memory_names ) ; end

То(/^личное имя имеет много памятей через памятные имена$/) do
   expect( @model ).to have_many( :memories ).through( :memory_names ) ; end

То(/^имя имеет столб(?:ец|цы) "([^"]*)" рода "(целый|строка)"$/) do |names, type_name|
   type = get_type( type_name )
   names.split( /,\s+/ ).each do |name|
      expect( @model ).to have_db_column( name ).of_type( type ) ; end ; end

То(/^русского имени ([^"]*) не будет$/) do |name|
   expect( Name.where(text: name) ).to match_array( [] ) ; end

То(/^русское отчество ([^"]*) будет существовать$/) do |patr|
   it = Patronymic.where( text: patr ).first
   expect( it ).to be_persisted ; end

То(/^русского отчества ([^"]*) не будет$/) do |patr|
   if @record
      expect( @record.errors.messages.values.join ).to include( 'Invalid text format detected' )
      expect( @record ).to_not be_persisted ; end
   expect( Patronymic.where(text: patr) ).to match_array( [] ) ; end

То(/^русская фамилия ([^"]*) будет существовать$/) do |fam|
   it = LastName.where( text: fam ).first
   expect( it ).to be_persisted ; end

То(/^русской фамилии ([^"]*) не будет$/) do |fam|
   if @record
      expect( @record.errors.messages.values.join ).to include( 'Invalid text format detected' )
      expect( @record ).to_not be_persisted ; end
   expect( LastName.where(text: fam) ).to match_array( [] ) ; end

То(/^(?:греческого|русского) личного имени ([^"]*) не будет$/) do |name|
   expect( Name.where(text: name) ).to match_array( [] ) ; end
