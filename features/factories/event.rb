FactoryGirl.define do
   factory :event do
      happened_at Date.today.to_s
      subject { Faker::Lorem.word }
      type { 'Birth' }

      association :memory
      association :place ;end ;end
