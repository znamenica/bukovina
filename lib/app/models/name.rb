class Name < ActiveRecord::Base
   has_many :memories, through: :memory_names
   has_many :memory_names

   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :лт ]

   validates_presence_of :language_code, :text
end
