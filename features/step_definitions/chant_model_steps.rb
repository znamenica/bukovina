Допустим(/^есть модель песнопения$/) do
   subject { Chant.new } ;end

Допустим(/^попробуем создать песнопение с полями:$/) do |table|
   sample { find_or_create( Chant, table.rows_hash ) } ; end

То(/^значение свойства "([^"]*)" .*? строго попадает в размер перечислителя$/) do |prop|
   begin
      expect( subject ).to validate_inclusion_of( prop ).
         in_array( subject.class.language_codes.keys )
   rescue ArgumentError => e
      # NOTE that is w/a
      /'(?<code>\d+)'/ =~ e.message
      expect( subject.class.language_codes.values ).to_not include( code )
      end ;end

То(/^значение свойства "([^"]*)" .*? строго попадает в размер "([^"]*)"$/) do |prop, range|
   expect( Chant.new ).to validate_inclusion_of( prop ).
      in_range( eval( range ) ) ;end

То(/^свойств[оа] "([^"]*)" .*? не мо(?:же|гу)т быть пустыми?$/) do |props|
   props.split(/,\s+/).each do |prop|
      expect( subject ).to validate_presence_of( prop ) ;end ;end

То(/^.*? имеет столб(?:ец|цы) "([^"]*)" рода "(целый|строка)"$/) do |names, type_name|
   type = get_type( type_name )
   names.split( /,\s+/ ).each do |name|
      expect( subject ).to have_db_column( name ).of_type( type ) ; end ; end


То(/^свойство "([^"]*)" .*? является перечислителем$/) do |prop|
   expect( subject ).to define_enum_for( prop ) ;end

То(/^.*? имеет много служебных песнопений$/) do
   expect( subject ).to have_many( :service_chants ) ;end

То(/^.*? имеет много служб через служебные песнопения$/) do
   expect( subject ).to have_many( :services ).through( :service_chants ) ;end

То(/^русских песнопений не будет$/) do
   expect( Chant.all ).to match_array( [] ) ;end

Допустим(/^создадим новое песнопение с полями:$/) do |table|
   find_or_create( Chant, table.rows_hash ) ;end

То(/^русское песнопенье "([^"]*)" будет существовать$/) do |text|
   it = Chant.where( text: text ).first
   expect( it ).to be_persisted ;end

То(/^греческого песнопения "([^"]*)" не будет$/) do |text|
   expect( sample.errors.messages.keys ).to match_array( [ :text ] )
   expect( sample.errors.messages.values.join ).to include(
      'contains invalid char(s) "Ваеилнопсю" for the specified language "гр"' )
   expect( sample ).to_not be_persisted
   expect( Chant.where(text: text) ).to match_array( [] ) ;end
