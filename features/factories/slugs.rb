FactoryGirl.define do
   factory :slug do
      text { Faker::Internet.slug }

      association :sluggable, factory: :calendary ;end;end
