class Bukovina::Importers::Name

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ; end

   def import
      @attrs.each do |attrs|
         # find name
         similar_to = attrs.delete( :similar_to )
         if similar_to
            s = similar_to.deep_dup
            s.delete( :similar_to )
            similar_to = Name.where( s ).first ; end

         r = Name.where( attrs ).first_or_initialize
         if similar_to
            r.similar_to = similar_to ; end
         r.save! ; end ; end ; end
