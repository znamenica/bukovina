Допустим(/^есть модель ссылки$/) do
   subject { Link.new } ; end

Допустим(/^есть модель вики ссылки$/) do
   subject { WikiLink.new } ; end

Допустим(/^есть модель бытийной ссылки$/) do
   subject { BeingLink.new } ; end

Допустим(/^есть модель иконной ссылки$/) do
   subject { IconLink.new } ; end

Допустим(/^есть модель отечниковой ссылки$/) do
   subject { PatericLink.new } ; end

Допустим(/^есть модель службеной ссылки$/) do
   subject { ServiceLink.new } ; end

Допустим(/^создадим новую вики ссылку с полями:$/) do |table|
   find_or_create( WikiLink, table.rows_hash ) ; end

Допустим(/^попробуем создать имя с полями:$/) do |table|
   sample { create( Name, table.rows_hash ) } ;end

Допустим(/^есть иконная ссылка "([^"]*)" без описания$/) do |url|
   FactoryGirl.create( :icon_link, url: url, description: false ) ; end

То(/^свойство "([^"]*)" модели есть включение описания с зависимостью удаления$/) do |prop|
   expect( subject ).to have_one( prop ).dependent( :destroy ) ; end

То(/^модель принимает вложенные настройки для свойства "([^"]*)"$/) do |prop|
   expect( subject ).to accept_nested_attributes_for( prop.to_sym )
end

То(/^вики ссылка на русский ресурс "([^"]*)" будет существовать$/) do |url|
   it = WikiLink.where( url: url ).first
   expect( it ).to be_persisted ; end

То(/^ссылки "([^"]*)" не будет$/) do |url|
   expect( sample ).to_not be_persisted
   expect( Link.where( url: url ) ).to be_empty ; end

То(/^иконная ссылка на русский ресурс "([^"]*)" будет действительной$/) do |url|
   expect( Link.where( url: url ).first ).to be_valid ; end

#То(/^иконная ссылка на русский ресурс "([^"]*)" будет недействительной$/) do |url|
#   expect( Link.where( url: url ).first ).to_not be_valid ; end

Если(/^попробуем создать новую вики ссылку с полями:$/) do |table|
   sample { create( WikiLink, table.rows_hash ) } ; end

Если(/^попробуем создать новую иконную ссылку "([^"]*)" с неверным описанием$/) do |url|
   sample { create :icon_link_with_invalid_description } ; end

То(/^увидим сообщение ссылки об ошибке:$/) do |string|
   messages = sample.errors.messages.map do |(name, texts)|
      texts.map do |text|
         "#{name.to_s.gsub(/\./,' ').capitalize} #{text}" ;end; end.flatten
   expect( messages ).to match_array( string.strip.split("\n") ) ;end

