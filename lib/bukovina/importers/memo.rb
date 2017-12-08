class Bukovina::Importers::Memo
   include Bukovina::Importers::FindInit

   def import
      @attrs.each do |attrs|
         # find name
         bond_to_marker = attrs.delete( :bond_to_marker )
         (search_attrs, new_attrs) = separate_hash( parse_hash( ::Memo, attrs ) )

         calendary_attrs = new_attrs.delete( :calendary_attributes )
         calendary_attrs[ :slugs ] = calendary_attrs.delete( :slugs_attributes )
         new_attrs[ :calendary ] = calendary_attrs.is_a?( Calendary ) &&
            calendary_attrs || Calendary.includes( :slug ).where( calendary_attrs ).first
         event_attrs = new_attrs.delete( :event_attributes )

         #Kernel.puts "EVENT: #{event_attrs.inspect}"
         new_attrs[ :event ] = event_attrs.is_a?( Event ) &&
            event_attrs || (
               memory_attrs = event_attrs.delete( :memory_attributes )
               event_attrs[ :memory ] = Memory.where( memory_attrs ).first
               Event.where( event_attrs ).first)

         search_attrs[ :calendary_id ] = new_attrs[ :calendary ].id
         search_attrs[ :event_id ] = new_attrs[ :event ].id
         if bond_to_marker
            base_search_attrs = search_attrs.merge(
               year_date: bond_to_marker,
               bind_kind: 'несвязаный' )
            memo = Memo.where( base_search_attrs ).first
            raise if !memo
            new_attrs[ :bond_to_id ] = memo.id ;end

         binding.pry if ENV['DEBUG']

         memo = Memo.new( new_attrs )
         memo.valid?

         search_attrs[ :year_date ] = memo.year_date
         #Kernel.puts "EVENT ATTRS: #{search_attrs.inspect}"
         Memo.where( search_attrs ).first || memo.save! #;end
      #rescue
      #   binding.pry
      end;end

   def initialize attrs, o_attrs = {}
      @attrs = [ attrs.deep_dup ].flatten ;end ;end
