class Name < ActiveRecord::Base
   self.abstract_class = true
   self.table_name = 'names'

   has_many :memories, through: :memory_names
   has_many :memory_names
   belongs_to :similar_to, class_name: :Name

   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :ла, :чх, :ир, :си, :бг,
      :ит, :ар, :ив, :рм, :са, :ис, :фр ]

   validates :text, text: true
   validates :language_code, inclusion: { in: self.language_codes }
   validates :language_code, :text, presence: true ; end
