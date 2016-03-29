class Bukovina::Importers::Service

   def import
      @attrs.each do |attrs|
         memory_attrs = attrs.delete( :memory )
         attrs[ :memory ] = Memory.where( memory_attrs ).first
         chants_attrs_list = attrs.delete( :chants )
         magnifications_attrs_list = attrs.delete( :magnifications )

         begin
         service =
         Service.where( attrs ).first_or_create( attrs.merge(
            chants_attributes: chants_attrs_list,
            magnifications_attributes: magnifications_attrs_list ) )
#         service = Service.where( attrs ).first_or_create
#         service.chants.create( create_attrs_list )
         rescue ActiveRecord::RecordNotUnique
            Kernel.puts attrs.inspect
            binding.pry
         rescue NoMethodError
            Kernel.puts attrs.inspect
            binding.pry
         end
         service
         ;end ;end
   private

   def initialize attrs
      @attrs = [ attrs.deep_dup ].flatten ;end ;end
