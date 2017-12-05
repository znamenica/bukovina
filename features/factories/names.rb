FactoryGirl.define do
   factory :name do
      text { FFaker::NameRU.first_name }
      alphabeth_code :ру
      language_code :ру ;end;end
