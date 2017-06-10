class CoordLink < Link
   belongs_to :info, inverse_of: :coordinate, polymorphic: true ;end
