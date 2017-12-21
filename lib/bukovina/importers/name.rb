class Bukovina::Importers::Name

   def find_or_init in_attrs
      attrs = in_attrs.deep_dup
      attrs.delete(:bind_kind)
      ::Name.where( attrs ).first || init( in_attrs ) ; end

   def init attrs
      Name.new( attrs ) ;end

   def import
      @attrs.map do |attrs|
         # find name
         bond_to = attrs.delete( :bond_to )
         r = find_or_init( attrs )

         if bond_to
            s = bond_to.deep_dup
            s.delete( :bond_to )
            bond_to = Name.where( s ).first
            r.bond_to = bond_to ; end

         begin
         r.save!
         rescue
            binding.pry
            raise $!
         end
         r ;end;end

   private

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ; end ; end
