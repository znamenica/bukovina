FactoryGirl.define do
   factory :order do
      text { FFaker::NameRU.first_name }
      alphabeth_code :ру
      language_code :ру
      order 'св' ;end;end
