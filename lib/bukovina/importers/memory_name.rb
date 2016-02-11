class Bukovina::Importers::MemoryName

   def initialize attrs, o_attrs = {}
      @o_attrs = o_attrs
      @attrs = [ attrs.deep_dup ].flatten ; end

   def import
      @attrs.each do |attrs|
         # find name
         name_attrs = attrs.delete( :name )
         name_attrs.delete( :similar_to )
         attrs[ :name ] = 
         begin
            Name.where( name_attrs ).first || raise
         rescue RuntimeError
            Bukovina::Importers::Name.new( name_attrs ).import
            retry ; end

         mn_attrs = attrs.merge( @o_attrs )
         MemoryName.where( mn_attrs ).first_or_initialize.save!
         end ; end ; end
