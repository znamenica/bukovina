FactoryGirl.define do
   factory :name do
      text { FFaker::NameRU.first_name }
      language_code :ру
   end
end
