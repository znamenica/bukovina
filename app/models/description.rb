class Description < ActiveRecord::Base
   belongs_to :describable, polymorphic: true

   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :ла, :чх, :ир, :си, :бг,
      :ит, :ар, :ив, :рм, :са, :ис, :фр ]

   validates :text, text: true
   validates :language_code, inclusion: { in: self.language_codes }
   validates :language_code, :text, presence: true ; end
