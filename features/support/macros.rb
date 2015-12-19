module MacrosSupport
   SUBATTRS = [ :short_name, :text ]

   def find_or_create model, search_attrs, attrs = {}
      search_attrs = search_attrs.to_a.map do |(attr, value)|
         if value =~ /^\*(.*)/
            submodel = eval( attr.camelize )
            subattr = SUBATTRS.select { |a| submodel.new.respond_to?( a ) }.first
            [ :"#{attr}_id", submodel.where( subattr => $1 ).first.id ]
         else
            [ attr, value ]
         end
      end.to_h
      model.where( search_attrs ).first_or_create attrs.merge( search_attrs )
   end

   def filter_array table, options = {}
      table.map do |e|
         e.map do |k, v|
            ! [ options[ :except ] ].include?( k ) && [ k, v.to_s ] || nil
         end.compact.to_h
      end
   end
end

World(MacrosSupport)
