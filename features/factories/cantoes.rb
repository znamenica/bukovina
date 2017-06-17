FactoryGirl.define do
   factory :canto do
      text { Faker::Lorem.paragraph }
      prosomeion_title { Faker::Lorem.word }
      language_code :ан
      alphabeth_code :ан
      tone 1
      type 'Canto'
      title { Faker::Lorem.word }
      author { Faker::Superhero.name }
      description { Faker::Lorem.sentence }
      ref_title { Faker::Lorem.word } ;end

   factory :orison, parent: :canto, class: :Orison do
      type 'Orison' ;end

   factory :canticle, parent: :canto, class: :Canticle do
      type 'Canticle' ;end

   factory :chant, parent: :canticle, class: :Chant do
      type 'Chant' ;end;end
