class Bukovina::Importers::Name

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ; end

   def import
      @attrs.each do |attrs|
         # find name
         attrs[ :language_code ] =
         ::Name.language_codes[ attrs[ :language_code ] ]

         similar_to = attrs.delete( :similar_to )
         if similar_to
            s = similar_to.deep_dup
            s[ :language_code ] =
            ::Name.language_codes[ similar_to[ :language_code ] ]
            s.delete( :similar_to )
            similar_to = ::Name.where( s ).first ; end

         r = ::Name.where( attrs ).first_or_initialize
         if similar_to
            r.similar_to = similar_to ; end
         r.save! ; end ; end ; end
