require 'bukovina/importers/common'

class Bukovina::Importers::Calendary < Bukovina::Importers::Common
   MODEL = :Calendary

   def import
      @attrs.each do |attrs|
         (search_attrs, new_attrs) = separate_hash( parse_hash( model, attrs ) )

         #binding.pry
         o = model.by_slug( new_attrs[:slug_attributes][:text] ).first_or_create!( new_attrs )

         errs = o.errors.map do |field, message|
            StandardError.new("#{field}: #{message}") ;end

         @errors.concat(errs) ;end;end;end
