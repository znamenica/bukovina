Допустим(/^есть модель службы$/) do
   subject { Service.new } ;end

Допустим(/^попробуем создать службу с полями:$/) do |table|
   sample { create( Service, table.rows_hash ) } ;end

То(/^служба имеет много песнопений через служебные песнопения$/) do
   expect( subject ).to have_many( :chants ).through( :service_chants ) ;end

То(/^.*? относится к памяти$/) do
   expect( subject ).to belong_to( :memory ) ;end

То(/^русских служб не будет$/) do
   expect( Service.count ).to be_zero ;end

Допустим(/^создадим новую службу с полями:$/) do |table|
   find_or_create( Service, table.rows_hash ) ;end

То(/^русская служба "([^"]*)" будет существовать$/) do |name|
   it = Service.where( name: name ).first
   expect( it ).to be_persisted ;end

То(/^греческой службы "([^"]*)" не будет$/) do |name|
   expect( sample.errors.messages.keys ).to match_array( [ :name ] )
   expect( sample.errors.messages.values.join ).to include(
      'contains invalid char(s) "Вабжилсую" for the specified language "гр"' )
   expect( sample ).to_not be_persisted
   expect( Service.where(name: name).count ).to be_zero ;end
