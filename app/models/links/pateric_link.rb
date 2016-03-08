require_relative '../link'

class PatericLink < Link
   belongs_to :memory, inverse_of: :pateric_links ; end
