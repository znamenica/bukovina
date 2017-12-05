class Bukovina::Importers::Name

   def find_or_init attrs
      Name.where( attrs ).first || init( attrs ) ; end

   def init attrs
      Name.new( attrs ) ;end

   def import
      @attrs.each do |attrs|
         # find name
         bond_to = attrs.delete( :bond_to )
         if bond_to
            s = bond_to.deep_dup
            s.delete( :bond_to )
            bond_to = Name.where( s ).first ; end

         r = find_or_init( attrs )
         if bond_to
            #binding.pry
            r.bond_to = bond_to ; end
         r.save! ;end;end

   private

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ; end ; end
