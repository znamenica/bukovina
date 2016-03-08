require_relative '../link'

class BeingLink < Link
   belongs_to :memory, inverse_of: :beings ; end
