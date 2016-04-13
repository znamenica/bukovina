class Bukovina::Importers::Service
#   MODEL = 'Service'

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
         when /^\*(?<newvalue>.*)/
            newvalue = $1
            raise "To be fixed #{attr} => #{value}"
            [ attr, $1 ]
         else
            [ attr, value ]
         end
      end.to_h
   end

   def separate_hash hash
      search_hash = hash.select { |(attr, _)| /_attributes\z/ !~ attr }.to_h
      [ search_hash, hash ] ;end

   def parse_array base, array
      array.map do |value|
         case value
         when Hash
            parse_hash( base, value )
         when /^\*(?<newvalue>.*)/
            base.find($1)
         else
            value
         end
      end
   end

   def import
      @attrs.each do |attrs|
         memory_attrs = attrs.delete( :memory )
         attrs[ :memory ] = Memory.where( memory_attrs ).first
         (search_attrs, attrs) = separate_hash( parse_hash( Service, attrs ) )
#         binding.pry

         begin
         service = Service.where( search_attrs ).first_or_create( attrs )
         rescue ActiveRecord::RecordNotUnique
            Kernel.puts attrs.inspect
            binding.pry
         rescue NoMethodError
            Kernel.puts attrs.inspect
            binding.pry
         end
         service ;end ;end

   private

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ;end ;end
