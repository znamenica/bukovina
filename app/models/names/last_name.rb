require_relative '../name'

class LastName < Name
   validates :text, last_name: true ; end
