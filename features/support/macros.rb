module MacrosSupport
   SUBATTRS = [ :short_name, :text ]

   def find_or_create model, search_attrs, attrs = {}
      search_attrs = search_attrs.to_a.map do |(attr, value)|
         if value =~ /^\*(.*)/
            submodel = eval( attr.camelize )
            subattr = SUBATTRS.select { |a| submodel.new.respond_to?( a ) }.first
            [ :"#{attr}_id", submodel.where( subattr => $1 ).first.id ]
         else
            value = value.is_a?( String ) && YAML.load( value ) || value
            [ attr, value ] ; end ; end.to_h
      model.where( search_attrs ).first_or_create attrs.merge( search_attrs ) ; end

   def get_type type_name
      { 'целый' => :integer, 'строка' => :string }[ type_name ] ; end

   def extract_key_to r, key
      similar_to = r.delete( key )
      if similar_to
         r[ key ] = Name.where( similar_to.deep_dup ).first ; end ; end

   def merge_array table, options = {}
      table.map do |e|
         [ options[ :merge ] ].compact.flatten.select{ |h| e[ h ] }.each do |h|
            e.merge!( e[ h ] )
            e.delete( h ) ; end
         e.map { |k, v| [ k, v.to_s ] }.to_h ; end ; end ; end

World(MacrosSupport)
