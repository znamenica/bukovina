Допустим(/^есть модель (#{kinds_re})$/) do |kind|
   subject { model_of( kind ).new } ;end

Допустим(/^попробуем создать (?:новую )?(#{kinds_re}) с полями:$/) do |kind, table|
   sample { create( model_of( kind ), table.rows_hash ) } ; end

То(/^значение свойства "([^"]*)" .*? строго попадает в размер перечислителя$/) do |prop|
   begin
      expect( subject ).to validate_inclusion_of( prop ).
         in_array( subject.class.language_codes.keys )
   rescue ArgumentError => e
      # NOTE that is w/a
      /'(?<code>\d+)'/ =~ e.message
      expect( subject.class.language_codes.values ).to_not include( code )
      end ;end

То(/^значение свойства "([^"]*)" ([^"]*?) строго попадает в размер "([^"]*)"$/) do |prop, kind, range|
   expect( model_of( kind ).new ).to validate_inclusion_of( prop ).
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

То(/^модель принимает вложенные настройки для свойства "([^"]*)"$/) do |prop|
   expect( subject ).to accept_nested_attributes_for( prop.to_sym ) ;end

То(/^свойство "([^"]*)" модели есть отношение к описываемому$/) do |prop|
   expect( subject ).to belong_to( prop ) ; end

То(/^.*? имеет много служебных песнопений$/) do
   expect( subject ).to have_many( :service_chants ) ;end

То(/^(?:(#{langs_re}) )?(#{kinds_re}) не будет$/) do |_, kind|
   expect( model_of( kind ).all ).to be_empty ;end

То(/^свойство "([^"]*)" модели есть включение описания с зависимостью удаления$/) do |prop|
   expect( subject ).to have_one( prop ).dependent( :destroy ) ; end

То(/^(#{langs_re}) (#{kinds_re}) "([^"]*)" будет действительной$/) do |_, kind, prop|
   expect( model_of( kind ).where( base_field( kind ) => prop ).first ).to be_valid ; end

Допустим(/^создадим нов(?:ое|ую) (#{kinds_re}) с полями:$/) do |kind, table|
   find_or_create( model_of( kind ), table.rows_hash ).save! ;end

То(/^(?:(#{langs_re}) )?(#{kinds_re}) "([^"]*)" будет существовать$/) do |_, kind, prop|
   relation = model_of( kind ).where( base_field( kind ) => prop )
   expect( relation ).to_not be_empty  ;end

То(/^(?:(#{langs_re}) )?(#{kinds_re}) "([^"]*)" не будет$/) do |_, kind, prop|
   expect( sample ).to_not be_persisted
   expect( model_of( kind ).where( base_field( kind ) => prop ) ).to be_empty ;end

То(/^увидим сообщение ссылки об ошибке:$/) do |string|
   messages = sample.errors.messages.map do |(name, texts)|
      texts.map do |text|
         "#{name.to_s.gsub(/\./,' ').capitalize} #{text}" ;end; end.flatten

   expect( messages ).to match_array( string.strip.split("\n") ) ;end
