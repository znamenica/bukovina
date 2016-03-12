Допустим(/^есть модель ссылки$/) do
   @model = Link.new ; end

Допустим(/^есть модель вики ссылки$/) do
   @model = WikiLink.new ; end

Допустим(/^есть модель бытийной ссылки$/) do
   @model = BeingLink.new ; end

Допустим(/^есть модель иконной ссылки$/) do
   @model = IconLink.new ; end

Допустим(/^есть модель отечниковой ссылки$/) do
   @model = PatericLink.new ; end

Допустим(/^есть модель службеной ссылки$/) do
   @model = ServiceLink.new ; end

Допустим(/^создадим новую вики ссылку с полями:$/) do |table|
   find_or_create( WikiLink, table.rows_hash ) ; end

Допустим(/^попробуем создать имя с полями:$/) do |table|
   expect{ Name.create( table.rows_hash ) }.to raise_error( NotImplementedError ) ; end

Допустим(/^есть иконная ссылка "([^"]*)" без описания$/) do |url|
   FactoryGirl.create( :icon_link, url: url, description: false ) ; end

То(/^свойство "([^"]*)" модели есть включение описания с зависимостью удаления$/) do |prop|
   expect( @model ).to have_one( prop ).dependent( :destroy ) ; end

То(/^модель принимает вложенные настройки для свойства "([^"]*)"$/) do |prop|
   expect( @model ).to accept_nested_attributes_for( prop.to_sym )
end

То(/^вики ссылка на русский ресурс "([^"]*)" будет существовать$/) do |url|
   it = WikiLink.where( url: url ).first
   expect( it ).to be_persisted ; end

То(/^ссылки "([^"]*)" не будет$/) do |url|
   expect( Link.where( url: url ) ).to be_empty ; end

То(/^иконная ссылка на русский ресурс "([^"]*)" будет действительной$/) do |url|
   expect( Link.where( url: url ).first ).to be_valid ; end

То(/^иконная ссылка на русский ресурс "([^"]*)" будет недействительной$/) do |url|
   binding.pry
   expect( Link.where( url: url ).first ).to_not be_valid ; end

Если(/^получим ошибку недействительной записи попытавшись создать новую вики ссылку с полями:$/) do |table|
   expect{ find_or_create( WikiLink, table.rows_hash ) }.to raise_error( ActiveRecord::RecordInvalid ) ; end

Если(/^получим ошибку недействительной записи попытавшись создать новую иконную ссылку "([^"]*)" с неверным описанием$/) do |url|
   expect{ create :icon_link_with_invalid_description }.to raise_error( ActiveRecord::RecordInvalid ) ; end
