class Bukovina::Importers::Mention

   def import
      @attrs.each do |attrs|
         # find name
         calendary_attrs = attrs.delete( :calendary )
         attrs[ :calendary ] = calendary_attrs.is_a?( Calendary ) &&
            calendary_attrs || Calendary.includes( :slug ).where( calendary_attrs ).first
         event_attrs = attrs.delete( :event )
         attrs[ :event ] = event_attrs.is_a?( Event ) &&
            event_attrs || Event.where( event_attrs ).first

         Mention.where( attrs ).first_or_create( attrs ) ;end ;end

   def initialize attrs, o_attrs = {}
      @attrs = [ attrs.deep_dup ].flatten ;end ;end
