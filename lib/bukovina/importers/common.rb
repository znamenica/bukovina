require 'bukovina/importers/find_init'

class Bukovina::Importers::Common
   include Bukovina::Importers::FindInit

   attr_reader :errors

   def model
      @model ||= self.class::MODEL.to_s.constantize
   end

   def import
      @attrs.each do |attrs|
         (search_attrs, new_attrs) = separate_hash( parse_hash( model, attrs ) )

         #binding.pry
         o = model.where( search_attrs ).first_or_create( new_attrs )

         errs = o.errors.map do |field, message|
            StandardError.new("#{field}: #{message}") ;end

         @errors.concat(errs) ;end;end

   def initialize attrs, o_attrs = {}
      @errors = []
      @attrs = [ attrs.deep_dup ].flatten ;end ;end
