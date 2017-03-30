FactoryGirl.define do
   factory :item_type do
      transient do
         ru_description 'Текст' ;end

      before( :create ) do |place, e|
         if e.ru_description.present?
            place.descriptions = build_list( :description, 1,
               describable: place, text: e.ru_description, alphabeth_code: :ру,
               language_code: :ру ) ;end ;end ;end ;end
