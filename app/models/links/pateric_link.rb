class PatericLink < Link
   belongs_to :info, inverse_of: :pateric_links, class_name: :Memory ; end
