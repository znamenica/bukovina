module Bukovina::Importers::FindInit
   def foreign_class base, attr
#            binding.pry
      if base.reflections[attr.to_s].source_reflection
         if base.reflections[attr.to_s].options[:class_name].present?
            base.reflections[attr.to_s].options[:class_name].to_s
         elsif base.reflections[attr.to_s].options[:as].present?
            'object'
         else
#            base.reflections[attr.to_s].foreign_key.to_s.gsub( "_id",'' )
            base.reflections[attr.to_s].name.to_s
         end
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
#            binding.pry
            new_base = foreign_class( base, attr )
#            binding.pry
            new_array = parse_array( new_base, value )
            if new_array.any? {|v| v.is_a?( Hash ) }
               [ :"#{attr}_attributes", new_array ]
            else
               [ attr, new_array ] ;end
         when Hash
#            binding.pry
            new_base = foreign_class( base, attr )
            new_value = parse_hash( new_base, value )
            if new_value.is_a?( Hash )
               [ :"#{attr}_attributes", new_value ]
            else
               [ attr, new_value ] ;end
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
#      binding.pry
      array.map do |value|
         case value
         when Hash
            parse_hash( base, value )
         when /^\*(.*)/
            base.find($1)
         else
            value ;end ;end ;end ;end
