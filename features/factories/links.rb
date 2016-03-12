FactoryGirl.define do
   factory :link do
      url { FFaker::Internet.http_url } ; end

   factory :language_link, parent: :link, class: LanguageLink do
      language_code :ру ; end

   factory :wiki_link, parent: :language_link, class: WikiLink do
      memory ; end

   factory :icon_link, parent: :link, class: IconLink do
      memory

      after( :build ) do |link, e|
         if e.description != false
            link.description = build :description, describable: link
            end ; end ; end

   factory :icon_link_with_invalid_description, parent: :icon_link do
      after( :build ) do |link, e|
         link.description = build :invalid_description, describable: link
         end ; end ; end
