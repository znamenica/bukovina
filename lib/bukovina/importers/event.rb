class Bukovina::Importers::Event

   def import
      @attrs.each do |attrs|
         # find name
         memory_attrs = attrs.delete( :memory )
         attrs[ :memory ] = memory_attrs.is_a?( Memory ) &&
            memory_attrs || Memory.where( memory_attrs ).first
         if place_attrs = attrs.delete( :place )
            desc_attrs = place_attrs.delete( :descriptions ).first
            attrs[ :place ] = Description.where( desc_attrs ).first.describable
            end

         Event.where( attrs ).first_or_create( attrs ) ;end ;end

   def initialize attrs, o_attrs = {}
      @attrs = [ attrs.deep_dup ].flatten ;end ;end
