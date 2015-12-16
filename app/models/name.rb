class Name < ActiveRecord::Base
   has_many :memories, through: :memory_names
   has_many :memory_names

   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :лт ]

   validates :text, format: { with: /[^\s]/ }
   validates :language_code, inclusion: { in: 0...self.language_codes.size }
   validates :language_code, :text, presence: true ; end
