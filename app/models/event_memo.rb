# type_class[string]    - тип события
# type_number[string]   - номер события
# memo_id[int]          - ссылка на помин
# event_id[int]         - ссылка на событий
#
class EventMemo < ActiveRecord::Base
   belongs_to :memo
   belongs_to :event

   validates :memo, presence: true ;end
