module MacrosSupport
   SUBATTRS = [ :short_name, :text, :url ]

   def sample &block
      if block_given?
         @sample_proc = block
      elsif @sample_proc
         @sample_proc.call ;end ;end

   def subject &block
      if block_given?
         @subject_proc = block
      else
         @subject_result = @subject_proc.call ;end ;end

   def expand_attributes model, search_attrs
      new_attrs = {}
      search_attrs.to_a.each do |(attr, value)|
         if value.is_a?( String ) && /^\*(?<match_value>.*)/ =~ value
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

      new_attrs ;end

   def create model, search_attrs = {}, attrs = {}
      if model.is_a?( Symbol )
         object = FactoryGirl.build( model, search_attrs )
         object.save
         object
      else
         new_attrs = expand_attributes( model, search_attrs )

         model.create( attrs.merge( new_attrs ) ) ;end ;end

   def find_or_create model, search_attrs, attrs = {}
      new_attrs = expand_attributes( model, search_attrs )

      model.where( new_attrs ).first_or_create(
         attrs.merge( new_attrs ) ) ; end

   def get_type type_name
      { 'целый' => :integer, 'строка' => :string }[ type_name ] ; end

   def base_field attr
      {  memory: :short_name,
         service: :name }[ attr.to_sym ] ;end

   def model_of name
      hash = { /тропар[ья]/   => Troparion,
               /величани[ея]/ => Magnification,
               /кондака?/     => Kontakion,
               /служб[аыу]/   => Service }

      hash.reduce( nil ) { |s, (re, model)| re =~ name && model || s }  ;end

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
