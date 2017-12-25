FactoryGirl.define do
   factory :description do
      text { FFaker::NameRU.name }
      language_code :ру
      alphabeth_code :ру ;end

   factory :appellation, class: :Appellation do
      type 'Appellation'
      text { FFaker::NameRU.name }
      language_code :ру
      alphabeth_code :ру ;end

   factory :note, class: :Note do
      type 'Note'
      text { FFaker::NameRU.name }
      language_code :ру
      alphabeth_code :ру ;end

   factory :invalid_description, parent: :description do
      text { 'Invalid' }
      language_code :ру
      alphabeth_code :ру ;end ;end
