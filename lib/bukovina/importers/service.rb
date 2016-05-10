class Bukovina::Importers::Service
#   MODEL = 'Service'

   attr_reader :errors

   def foreign_class base, attr
               #new_base = attr.to_s.singularize.camelize.constantize
      if base.reflections[attr.to_s].source_reflection
         base.reflections[attr.to_s].foreign_key.to_s.gsub( "_id",'' )
      else
         through = base.reflections[attr.to_s].through_reflection
         through_class = through.class_name.constantize
         if class_name = base.reflections[attr.to_s].options[:class_name]
            class_name.to_s
         else
            foreign_key = base.reflections[attr.to_s].options[ :foreign_key ]
            kind = foreign_key.to_s.gsub( "_id",'' )
            through_class.reflections[ kind ].name.to_s ;end ;end
      .classify.constantize ;end

   def parse_hash base, hash
      hash.map do |(attr, value)|
         case value
         when Array
            new_base = foreign_class( base, attr )
            new_array = parse_array( new_base, value )
            if new_array.any? {|v| v.is_a?( Hash ) }
               [ :"#{attr}_attributes", new_array ]
            else
               [ attr, new_array ] ;end
         when /\A\*(?<newvalue>.*)/
            newvalue = $1
            raise "To be fixed so: attr #{attr} => #{value}"
            [ attr, value ]
         else
            [ attr, value ] ;end ;end
      .to_h ;end

   def separate_hash hash
      search_hash = hash.select { |(attr, _)| /_attributes\z/ !~ attr }.to_h
      [ search_hash, hash ] ;end

   def parse_array base, array
      array.map do |value|
         case value
         when Hash
            parse_hash( base, value )
         when /^\*(.*)/
            base.find($1)
         else
            value ;end ;end ;end

   def import
      @attrs.map do |attrs|
         memory_attrs = attrs.delete( :memory )
         attrs[ :info ] = memory_attrs.is_a?( Memory ) &&
            memory_attrs || Memory.where( memory_attrs ).first
         (search_attrs, new_attrs) = separate_hash( parse_hash( Service, attrs ) )

         begin
            service = Service.where( search_attrs ).first_or_create( new_attrs )
         rescue ActiveRecord::RecordNotUnique
            if /(?<base>.*) (?<number>\d+)\z/ =~ new_attrs[:name]
               new_attrs[:name] = "#{base} #{number.to_i + 1}"
            else
               new_attrs[:name] += ' 1'
            end

            search_attrs[:name] = new_attrs[:name]

            retry
         end

         if service && service.errors.size > 0
            @errors << ActiveRecord::RecordInvalid.new(service) ;end

         service ;end ;end

   private

   def initialize attrs
      @errors = []
      @attrs = [ attrs.deep_dup ].flatten ;end ;end
