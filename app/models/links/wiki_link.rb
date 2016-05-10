class WikiLink < Link
   belongs_to :info, inverse_of: :wikies, polymorphic: true ;end
