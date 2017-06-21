require 'bukovina/importers/common'

class Bukovina::Importers::Memory < Bukovina::Importers::Common
   def import short_name
      @short_name = short_name
      @attrs.each do |attrs|
         attrs = attrs.merge(short_name: short_name)

         (search_attrs, new_attrs) = separate_hash( parse_hash( ::Memory, attrs ) )

         o = ::Memory.unscoped.where( search_attrs ).first_or_initialize( new_attrs )

         if not o.valid? and o.errors.details.keys.grep(/(icon_links|photo_links).url/).any?
            urls = ( o.errors["icon_links.url"] |
                     o.errors["events.icon_links.url"] |
                     o.errors["photo_links.url"] ).map do |x|
               x.values.first =~ /'([^']*)'/ && $1 ;end
            links = ( o.icon_links |
                      o.events.map { |e| e.icon_links }.flatten |
                      o.photo_links ).select { |l| urls.include?(l.url) }
            o.events.each { |e| e.icon_links.delete(links) }
            o.photo_links.delete(links)
            o.icon_links.delete(links) ;end

         binding.pry if not o.valid? #or not o.persisted?
         begin
            o.memory_names.each { |mn| mn.name.save }
            o.save!
         rescue ActiveRecord::RecordNotUnique
            if $!.message =~ /: names\.|index_names_on_text_and_type_and_alphabeth_code/
               (search_attrs, new_attrs) = separate_hash( parse_hash( ::Memory, attrs ) )
               o = Memory.unscoped.where( search_attrs ).first_or_initialize( new_attrs )
               retry
            else
               raise $! ;end;end

         errs = o.errors.map do |field, message|
            StandardError.new("#{field}: #{message}") ;end

         @errors.concat(errs) ;end;end;end
