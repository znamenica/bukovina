Если(/^попробуем создать новое событие с неверным описанием$/) do
   sample { create :event, :with_invalid_description } ; end
