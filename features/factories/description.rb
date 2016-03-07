FactoryGirl.define do
   factory :description do
      text { FFaker::NameRU.name }
      language_code :ру ; end

   factory :invalid_description, parent: :description do
      text { FFaker::Name.name }
      language_code :ру ; end ; end
