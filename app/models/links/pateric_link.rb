class PatericLink < Link
   belongs_to :info, polymorphic: true, inverse_of: :paterics; end
