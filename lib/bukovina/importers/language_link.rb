require_relative 'link'

class Bukovina::Importers::LanguageLink < Bukovina::Importers::Link

   def import
      @attrs.each do |attrs|
         memory_attrs = attrs.delete( :memory )
         attrs[ :memory ] = Memory.where( memory_attrs ).first

         begin
         self.class::TYPE.to_s.constantize.where( attrs ).first_or_create
         rescue ActiveRecord::RecordNotUnique
            Kernel.puts attrs.inspect
            binding.pry
         end
         ; end ; end ; end
