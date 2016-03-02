class Bukovina::Importers::Name

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ; end

   def create attrs
      r = Name.where( attrs ).first
      if ! r
         [ LastName, Patronymic, FirstName ].reduce( nil ) do |res, model|
            if ! res
               r = model.create( attrs )
               r.valid? && r || nil
            else
               res ; end ; end ; end ; end

   def import
      @attrs.each do |attrs|
         # find name
         similar_to = attrs.delete( :similar_to )
         if similar_to
            s = similar_to.deep_dup
            s.delete( :similar_to )
            similar_to = Name.where( s ).first ; end

         r = create( attrs )
         if similar_to
            r.similar_to = similar_to ; end
         r.save! ; end ; end ; end
