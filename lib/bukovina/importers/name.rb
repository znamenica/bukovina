class Bukovina::Importers::Name

   def find_or_init attrs
      Name.where( attrs ).first || init( attrs ) ; end

   def init attrs
      r = [ LastName, Patronymic ].reduce( nil ) do |res, model|
         if ! res
            r = model.new( attrs )
            r.valid? && r || nil
         else
            res ; end ; end
      r || FirstName.new( attrs ) ; end

   def import
      @attrs.each do |attrs|
         # find name
         similar_to = attrs.delete( :similar_to )
         if similar_to
            s = similar_to.deep_dup
            s.delete( :similar_to )
            similar_to = Name.where( s ).first ; end

         r = find_or_init( attrs )
         if similar_to
            r.similar_to = similar_to ; end
         r.save! ; end ; end

   private

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ; end ; end
