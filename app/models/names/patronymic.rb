require_relative '../name'

class Patronymic < Name
   validates :text, patronymic: true ; end
