class Bukovina::Importers::Event

   def foreign_class base, attr
#      binding.pry
      if class_name = base.reflections[ attr.to_s ].class_name
         class_name
      elsif base.reflections[ attr.to_s ].source_reflection
         if base.reflections[ attr.to_s ].options[ :as ].present?
            'object'
         else
            base.reflections[ attr.to_s ].foreign_key.to_s.gsub( "_id",'' )
         end
      else
         if class_name = base.reflections[ attr.to_s ].class_name
            class_name.to_s
         else
            through = base.reflections[ attr.to_s ].through_reflection
            through_class = through.class_name.constantize
            foreign_key = base.reflections[ attr.to_s ].options[ :foreign_key ]
            kind = foreign_key.to_s.gsub( "_id",'' )
            through_class.reflections[ kind ].name.to_s ;end ;end
      .classify.constantize ;end

   def parse_hash base, hash
      hash.map do |(attr, value)|
         case value
         when Array
            new_base = foreign_class( base, attr )
            new_array = parse_array( new_base, value )
            if new_array.any? { |v| v.is_a?( Hash ) }
               [ :"#{attr}_attributes", new_array ]
            else
               [ attr, new_array ] ;end
         when Hash
            new_base = foreign_class( base, attr )
            h = parse_hash( new_base, value )
            ar = h.values.select { |x| x.is_a?( ActiveRecord::Base ) }.first
            ar && [ attr, ar ] || [ :"#{attr}_attributes", h ]
         when /\A\*(?<newvalue>.*)/
            [ attr, base.where( attr => $1 ).first ]
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
      @attrs.each do |attrs|
         (search_attrs, new_attrs) = separate_hash( parse_hash( Event, attrs ) )

         binding.pry
         Event.where( search_attrs ).first_or_create( new_attrs ) ;end ;end

   def initialize attrs, o_attrs = {}
      @attrs = [ attrs.deep_dup ].flatten ;end ;end
