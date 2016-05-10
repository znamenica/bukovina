class IconLink < Link
   belongs_to :info, inverse_of: :icon_links, polymorphic: true

   has_one :description, as: :describable, dependent: :destroy

   accepts_nested_attributes_for :description, reject_if: :all_blank

   validates :description, associated: true ; end
