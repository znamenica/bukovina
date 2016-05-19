FactoryGirl.define do
   factory :place do
      transient do
         ru_description false ;end

      before( :create ) do |place, e|
         if e.ru_description.present?
            place.descriptions = build_list( :description, 1,
               describable: place, text: e.ru_description, alphabeth_code: :ро,
               language_code: :ру ) ;end ;end ;end ;end
