FactoryGirl.define do
   factory :name do
      text { FFaker::NameRU.first_name }
      alphabeth_code :ру
      language_code :ру ;end

   factory :first_name, parent: :name, class: :FirstName do
      type 'FirstName' ;end

   factory :last_name, parent: :name, class: :LastName do
      type 'LastName' ;end

   factory :nick_name, parent: :name, class: :NickName do
      type 'NickName' ;end

   factory :patronymic, parent: :name, class: :Patronymic do
      type 'Patronymic' ;end;end
