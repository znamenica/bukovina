require 'excon'

class IconLink < Link
   belongs_to :info, polymorphic: true

   has_one :description, as: :describable, dependent: :destroy

   accepts_nested_attributes_for :description, reject_if: :all_blank

   # validates :url, format: { with: /\.(?i-mx:jpg|png)\z/ }
   validates :description, associated: true
   validate :url, :accessible_image
   
   def accessible_image
      response = Excon.get(URI.encode(url))

      if response.status.eql?(301)
         new_url = response[:headers]["Location"]
         response = Excon.get(URI.encode(new_url)) ;end

      if not response.status.eql?(200)
         raise Excon::Error::Socket ;end
   rescue Excon::Error::Socket, Excon::Error::Timeout
      errors.add(:url, inaccessible: "The url '#{url}' is inaccessible") ;end;end
