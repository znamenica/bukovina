require_relative '../link'

class IconLink < Link
   belongs_to :memory, inverse_of: :icon_links

   has_one :description, as: :describable, dependent: :destroy

   accepts_nested_attributes_for :description, reject_if: :all_blank

   validates_associated :description ; end
