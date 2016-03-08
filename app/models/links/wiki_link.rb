require_relative '../link'

class WikiLink < Link
   belongs_to :memory, inverse_of: :wikies ; end
