class Name < ActiveRecord::Base
   has_and_belongs_to_many :memories

   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :лт ]

   validates_presence_of :language_code, :text
end
