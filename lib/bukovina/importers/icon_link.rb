require_relative 'link'

class Bukovina::Importers::IconLink < Bukovina::Importers::Link

   def import
      @attrs.each do |attrs|
         memory_attrs = attrs.delete( :memory )
         attrs[ :info ] = Memory.where( memory_attrs ).first
         create_attrs = attrs.delete( :description )

         IconLink.where( attrs ).first_or_create( attrs.merge(
            { description_attributes: create_attrs || {} } ) ) ;end ;end ;end
