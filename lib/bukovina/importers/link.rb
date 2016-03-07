class Bukovina::Importers::Link

   def import
      @attrs.each do |attrs|
         memory_attrs = attrs.delete( :memory )
         attrs[ :memory ] = Memory.where( memory_attrs ).first
         create_attrs = attrs.delete( :description )

         begin
         self.class::TYPE.to_s.constantize.where( attrs ).first_or_create( attrs.merge({ description_attributes: create_attrs }))
         rescue ActiveRecord::RecordNotUnique
            Kernel.puts attrs.inspect
            binding.pry
         end
         ; end ; end

   private

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ; end ; end
