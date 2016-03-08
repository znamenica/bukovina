class Link < ActiveRecord::Base
   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :ла, :чх, :ир, :си, :бг,
      :ит, :ар, :ив, :рм, :са, :ис, :фр ]

   validates :url, url: { no_local: true }
   validates :memory_id, :type, presence: true ; end
