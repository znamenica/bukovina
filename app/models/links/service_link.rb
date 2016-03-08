require_relative '../link'

class ServiceLink < Link
   belongs_to :memory, inverse_of: :service_links ; end
