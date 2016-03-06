class Link < ActiveRecord::Base
   belongs_to :memory

   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :ла, :чх, :ир, :си, :бг,
      :ит, :ар, :ив, :рм, :са, :ис, :фр ]

   validates :url, url: { no_local: true }
   validates :language_code, inclusion: { in: self.language_codes }
   validates :language_code, :url, presence: true ; end
