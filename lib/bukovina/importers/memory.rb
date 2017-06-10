require 'bukovina/importers/common'

class Bukovina::Importers::Memory < Bukovina::Importers::Common
   def import short_name
      @short_name = short_name
#         binding.pry
      @attrs.each do |attrs|
         attrs = attrs.merge(short_name: short_name)
#         name = attrs.delete( :name )
#         if name
#            name.each do |_attrs|
#               Bukovina::Importers::Name.new(_attrs).import ; end
#
#            o_attrs = { memory: memory }
#            attr_lists[ :memory_name ].each do |attrs|
#               Bukovina::Importers::MemoryName.new(attrs, o_attrs).import ;end;end
#
         (search_attrs, new_attrs) = separate_hash( parse_hash( Memory, attrs ) )

#         binding.pry
         o = Memory.where( search_attrs ).first_or_initialize( new_attrs )

#         binding.pry
         binding.pry if not o.valid? #or not o.persisted?
         begin
            o.memory_names.each { |mn| mn.name.save }
            o.save!
         rescue ActiveRecord::RecordNotUnique
            if $!.message =~ /: names\./
               (search_attrs, new_attrs) = separate_hash( parse_hash( Memory, attrs ) )
               o = Memory.where( search_attrs ).first_or_initialize( new_attrs )
               retry
            else
               raise $!
            end
         end


         errs = o.errors.map do |field, message|
            StandardError.new("#{field}: #{message}") ;end

         @errors.concat(errs) ;end;end;end
