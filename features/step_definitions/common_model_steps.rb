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

То(/^(?:(#{langs_re}) )?(#{kinds_re}) не будет$/) do |_, kind|
   expect( model_of( kind ).all ).to be_empty ;end

То(/^свойство "([^"]*)" модели есть включение описания с зависимостью удаления$/) do |prop|
   expect( subject ).to have_one( prop ).dependent( :destroy ) ; end

То(/^(#{langs_re}) (#{kinds_re}) "([^"]*)" будет действительной$/) do |_, kind, prop|
   expect( model_of( kind ).where( base_field( kind ) => prop ).first ).to be_valid ; end

Допустим(/^создадим нов(?:ое|ую) (#{kinds_re}) с полями:$/) do |kind, table|
   find_or_create( model_of( kind ), table.rows_hash ).save! ;end

То(/^(?:(?:#{langs_re}) )?(#{kinds_re}) "([^"]*)" будет существовать$/) do |kind, prop|
   relation = model_of( kind ).where( base_field( kind ) => prop )
   expect( relation ).to_not be_empty  ;end

То(/^(?:(?:#{langs_re}) )?(#{kinds_re}) "([^"]*)" не будет$/) do |kind, prop|
   expect( sample ).to_not be_persisted
   expect( model_of( kind ).where( base_field( kind ) => prop ) ).to be_empty ;end

То(/^должны быть пустыми следующие свойства (#{kinds_re}):$/) do |kind, table|
   expect( subject ).to be_a( model_of( kind ) )
   table.hashes.map(&:values).flatten.each do |attr|
      expect( subject ).to validate_absence_of( attr.to_sym ) ;end ;end

То(/^не могут быть пустыми следующие свойства (#{kinds_re}):$/) do |kind, table|
   expect( subject ).to be_a( model_of( kind ) )
   table.hashes.map(&:values).flatten.each do |attr|
      expect( subject ).to validate_presence_of( attr.to_sym ) ;end ;end

То(/^(#{kinds_re}) имеет рода "([^"]*)" следущие столбцы:$/) do |kind, type_name, table|
   type = get_type( type_name )
   expect( subject ).to be_a( model_of( kind ) )
   table.hashes.map( &:values ).flatten.each do |attr|
      expect( subject ).to have_db_column( attr ).of_type( type ) ; end ; end

То(/^(#{kinds_re}) имеет много (#{kinds_re})$/) do |kind, relation|
   expect( subject ).to be_a( model_of( kind ) )
   expect( subject ).to have_many( relation_of( relation ) ) ;end

То(/^(#{kinds_re}) имеет много (#{kinds_re}) через (#{kinds_re})$/) do |kind, relation, through|
   expect( subject ).to be_a( model_of( kind ) )
   expect( subject ).to have_many( relation_of( relation ) )
   .through( relation_of( through ) ) ;end

То(/^увидим сообщение (#{kinds_re}) об ошибке:$/) do |kind, string|
   expect( sample ).to be_a( model_of( kind ) )
   messages = sample.errors.messages.map do |(name, texts)|
      texts.map do |text|
         "#{name.to_s.gsub(/\./,' ').capitalize} #{text}" ;end; end
      .flatten

   expect( messages ).to match_array( string.strip.split("\n") ) ;end
