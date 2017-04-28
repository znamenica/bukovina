FactoryGirl.define do
   factory :event do
      happened_at Date.today.to_s
      type { 'Birth' }

      association :item
      association :memory
      association :place ;end ;end
