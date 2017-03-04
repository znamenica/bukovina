Если(/^попробуем создать новый тип предмета без описаний$/) do
   sample { create :item_type, descriptions: [] }
end

Если(/^попробуем создать новый тип предмета с неверным описанием$/) do
   sample { create :item_type,
      descriptions: FactoryGirl.build_list( :invalid_description, 1 ) }
end
