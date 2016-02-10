class Name < ActiveRecord::Base
   has_many :memories, through: :memory_names
   has_many :memory_names
   belongs_to :similar_to, class_name: :Name

   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :ла, :чх, :ир, :си, :бг,
      :ит, :ар, :ив, :рм, :са ]

   validates :text, format: { with: /[^\s]/ }
   validates :language_code, inclusion: { in: self.language_codes }
   validates :language_code, :text, presence: true ; end
