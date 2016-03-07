FactoryGirl.define do
   factory :link do
      url { FFaker::Internet.http_url }
      language_code :ру ; end

   factory :wiki_link, parent: :link, class: WikiLink do
      memory

      after( :build ) do |link, e|
         if e.description != false
            link.description = build :description, describable: link
            end ; end ; end

   factory :wiki_link_with_invalid_description, parent: :wiki_link do
      after( :build ) do |link, e|
         link.description = build :invalid_description, describable: link
         end ; end ; end
