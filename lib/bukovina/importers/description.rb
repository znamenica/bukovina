class Bukovina::Importers::Description

   def import
      @attrs.each do |attrs|
         memory_attrs = attrs.delete( :memory )
         attrs[ :memory ] = Memory.where( memory_attrs ).first

         begin
         Description.where( attrs ).first_or_create 
         rescue ActiveRecord::RecordNotUnique
            p 1111111
            Kernel.puts attrs.inspect
         end
         
         
         ; end ; end

   private

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ; end ; end
