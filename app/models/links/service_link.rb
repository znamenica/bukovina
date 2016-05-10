class ServiceLink < Link
   belongs_to :info, inverse_of: :service_links, polymorphic: true ;end
