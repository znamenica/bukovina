class Bukovina::Importers::MemoryName

   def initialize attrs, o_attrs = {}
      @o_attrs = o_attrs
      @attrs = [ attrs.deep_dup ].flatten ; end

   def import
      @attrs.each do |attrs|
         # find name
         name_attrs = attrs.delete( :name )
         name_attrs[ :language_code ] =
         Name.language_codes[ name_attrs[ :language_code ] ]
         similar_to = name_attrs.delete( :similar_to )
         attrs[ :name ] = 
         begin
            Name.where( name_attrs ).first || raise
         rescue RuntimeError
            Bukovina::Importers::Name.new( name_attrs ).import
            retry ; end

         if attrs[ :state ]
            attrs[ :state ] = MemoryName.states[ attrs[ :state ] ] ; end
         if attrs[ :mode ]
            attrs[ :mode ] = MemoryName.modes[ attrs[ :mode ] ] ; end
         if attrs[ :feasibly ]
            attrs[ :feasibly ] = MemoryName.feasiblies[ attrs[ :feasibly ] ] ; end

         mn_attrs = attrs.merge( @o_attrs )
         MemoryName.where( mn_attrs ).first_or_initialize.save!
         end ; end ; end
