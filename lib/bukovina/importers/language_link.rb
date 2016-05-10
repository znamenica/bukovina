require_relative 'link'

class Bukovina::Importers::LanguageLink < Bukovina::Importers::Link

   def import
      @attrs.each do |attrs|
         memory_attrs = attrs.delete( :memory )
         attrs[ :info ] = Memory.where( memory_attrs ).first

         self.class::TYPE.to_s.constantize.where( attrs ).first_or_create
         end ; end ; end
