Допустим(/^есть иконная ссылка "([^"]*)" без описания$/) do |url|
   FactoryGirl.create( :icon_link, url: url, description: false ) ; end

Если(/^попробуем создать новую иконную ссылку "([^"]*)" с неверным описанием$/) do |url|
   sample { create :icon_link, :with_invalid_description } ; end
