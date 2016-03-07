module MacrosSupport
   SUBATTRS = [ :short_name, :text, :url ]

   def find_or_create model, search_attrs, attrs = {}
      new_attrs = {}
      search_attrs.to_a.each do |(attr, value)|
         if /^\*(?<match_value>.*)/ =~ value
            /(?<attr>[^:]*)(?::(?<modelname>.*))?/ =~ attr
            submodel = ( modelname || attr ).camelize.constantize
            subattr = SUBATTRS.select { |a| submodel.new.respond_to?( a ) }.first
            new_attrs[ :"#{attr}_id" ] =
            submodel.where( subattr => match_value ).first.id
            if model.new.respond_to?( "#{attr}_type" )
               new_attrs[ :"#{attr}_type" ] = modelname.camelize ; end
         else
            value = value.is_a?( String ) && YAML.load( value ) || value
            new_attrs[ attr ] = value ; end ; end

      model.where( new_attrs ).first_or_create!(
         attrs.merge( new_attrs ) ) ; end

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
