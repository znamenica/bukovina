module Bukovina::Importers::FindInit
   def foreign_class base, attr
      a= if not base.reflections[attr.to_s]
         'array'
      elsif base.reflections[attr.to_s].source_reflection
         if base.reflections[attr.to_s].options[:class_name].present?
            base.reflections[attr.to_s].options[:class_name]
         elsif base.reflections[attr.to_s].options[:source].present?
            base.reflections[attr.to_s].options[:source]
         elsif base.reflections[attr.to_s].options[:as].present?
            attr
         else
#            base.reflections[attr.to_s].foreign_key.to_s.gsub( "_id",'' )
            base.reflections[attr.to_s].name
         end
      else
         through = base.reflections[attr.to_s].through_reflection
         through_class = through.class_name.constantize
#         binding.pry
         if class_name = base.reflections[attr.to_s].options[:class_name]
            class_name
         else
            foreign_key = base.reflections[attr.to_s].options[ :foreign_key ]
            kind = foreign_key.to_s.gsub( "_id",'' )
            through_class.reflections[ kind ].name ;end ;end
#      binding.pry if attr == :memory_names
#      binding.pry if attr == :descriptions


      a.to_s.classify.constantize
   rescue
      binding.pry ;end

   def parse_hash base, hash
      hash.map do |(attr, value)|
         case value
         when Array
            binding.pry if ! base.respond_to?(:reflections)#.reflections[attr.to_s]
            new_base = foreign_class( base, attr )
#            binding.pry
#            binding.pry if ! new_base.respond_to?(:reflections)#.reflections[attr.to_s]
            new_array = parse_array( new_base, value )
            if new_array.any? {|v| v.is_a?( Hash ) }
               [ :"#{attr}_attributes", new_array ]
            else
               [ attr, new_array ] ;end
         when Hash
#            binding.pry if ! base.reflections[attr.to_s]
            binding.pry if ! base.respond_to?(:reflections)#.reflections[attr.to_s]
            new_base = foreign_class( base, attr )
#            binding.pry if ! new_base.respond_to?(:reflections)#.reflections[attr.to_s]
            new_value = parse_hash( new_base, value )
            if new_value.is_a?( Hash )
               [ :"#{attr}_attributes", new_value ]
            else
               [ attr, new_value ] ;end
#         when /\A\*(?<newvalue>.*)/
#            newvalue = $1
#            raise "To be fixed so: attr #{attr} => #{value}"
#            [ attr, value ]
         else
            [ attr, value ] ;end;end
      .compact.to_h
   rescue
      binding.pry ;end

   def separate_hash hash
      search_hash = hash.select { |(attr, _)| /_attributes\z/ !~ attr }.to_h
      [ search_hash, hash ] ;end

   def parse_array base, array
#      binding.pry
      array.map do |value|
         case value
         when Hash
            binding.pry if ! base.respond_to?(:reflections)#.reflections[attr.to_s]
            parse_hash( base, value )
         when /^\*(.*)/
            $1.present? && value || "^#{@short_name}"
         else
            value ;end ;end ;end ;end
