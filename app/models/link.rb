class Link < ActiveRecord::Base
   has_one :description, as: :describable, dependent: :destroy

   enum language_code: [ :цс, :ру, :ср, :гр, :ан, :ла, :чх, :ир, :си, :бг,
      :ит, :ар, :ив, :рм, :са, :ис, :фр ]

   accepts_nested_attributes_for :description, reject_if: :all_blank

   validates_associated :description

   validates :url, url: { no_local: true }
   validates :language_code, inclusion: { in: self.language_codes }
   validates :language_code, :url, :type, presence: true
   validates :language_code,
      inclusion: { in: proc { |link| link.description&.language_code } },
      if: ->{ self.description } ; end
