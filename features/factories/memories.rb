FactoryGirl.define do
   factory :memory do
      short_name { FFaker::NameRU.name }
      order 'св'

      after( :build ) do |m|
         m.events << build( :event, memory: m ) ;end;end;end
