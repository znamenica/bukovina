Допустим(/^есть русское личное имя (.*)$/) do |name|
   find_or_create( Name, { text: name }, language_code: :ру,
      alphabeth_code: :ру ) ; end

Допустим(/^имя (.*) относится к памяти "(.*)"$/) do |nametext, short_name|
   memory = Memory.where( short_name: short_name ).first
   name = Name.where( text: nametext ).first
   if !memory.names.include? name
      memory.names << name ; end ; end

Допустим(/^применим входные данные модели имени:$/) do |string|
   data = YAML.load( string )
   data.each do |r|
      extract_key_to( r, :bond_to )
      name = Name.create( r ) ; end ; end

То(/^будут существовать русские личные имена "([^"]*)"$/) do |names|
   names.split( /,\s+/ ).each do |name|
      expect( Name.where( text: name, language_code: :ру ).first ).to_not be_nil
      end ; end

То(/^будет существовать (сербское|греческое|английское) личное имя "([^"]*)"$/) do |lang, name|
   lcode = { сербское: :сх, греческое: :гр, английское: :ан }[ lang.to_sym ]
   expect( Name.where( text: name, language_code: lcode ).first ).to_not be_nil
   end

То(/^свойство "([^"]*)" имени "([^"]*)" будет указывать на личное имя "([^"]*)"$/) do |prop, name, target_name|
   name_r = Name.where( text: name ).first
   expect( name_r.send( prop ) ).to be_eql( Name.where( text: target_name ).first )
   end

То(/^свойство "([^"]*)" личного имени есть отношение к имени" $/) do |prop|
   expect( subject ).to belong_to( prop ).class_name( :Name ) ; end

То(/^личное имя имеет много памятных имён$/) do
   expect( subject ).to have_many( :memory_names ) ; end

То(/^личное имя имеет много памятей через памятные имена$/) do
   expect( subject ).to have_many( :memories ).through( :memory_names ) ; end

То(/^русского имени "([^"]*)" не будет изза неверного типа$/) do |text|
   expect( sample ).to_not be_persisted
   expect( sample.errors.messages.keys ).to match_array( [ :type ] )
   expect( sample.errors.messages.values.join ).to include(
      "can't be blank" )
   expect( Name.all ).to be_empty ;end

То(/^русско(?:й|го) (.*) "([^"]*)" не будет изза неверного вида$/) do |kind, text|
   expect( sample ).to_not be_persisted
   expect( sample.errors.messages.keys ).to match_array( [ :text ] )
   expect( sample.errors.messages.values.join ).to match(
      /has invalid form for a/ )
   expect( Name.all ).to be_empty ;end
