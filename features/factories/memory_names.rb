FactoryGirl.define do
   factory :memory_name do
      state :наречёное
      feasibly :non_feasible

      association :memory, factory: :memory
      association :name, factory: :name
   end
end
