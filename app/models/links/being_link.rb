class BeingLink < Link
   belongs_to :info, inverse_of: :beings, polymorphic: true ;end
