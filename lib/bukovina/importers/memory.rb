require 'bukovina/importers/common'

class Bukovina::Importers::Memory < Bukovina::Importers::Common

   def init_slug o
      o.slug = Slug.new(base: o.short_name) if o.slug.blank?
      base = o.slug.text.gsub(/[^0-9а-яё]/, 'а').unpack("U*")
      nums = base.dup
      while Slug.where(text: nums.pack("U*")).present?
         Kernel.puts "slug #{nums.pack("U*")} found"
         nums[-1] =
         case nums.last
         when base.last - 1 < 'а'.ord && 'я'.ord || base.last - 1
            nums[-2] =
            case nums[-2]
            when base[-2] - 1 < 'а'.ord &&  'я'.ord || base[-2] - 1
               raise
            when 'я'.ord
               'ё'.ord
            when 'ё'.ord
               'а'.ord
            else
               nums[-2] + 1 ;end
            nums.last == 'я'.ord && 'а'.ord || nums.last + 1
         when 'я'.ord
            'ё'.ord
         when 'ё'.ord
            'а'.ord
         else
            nums.last + 1 ;end;end
      o.slug.text = nums.pack("U*")
      Kernel.puts "new slug #{o.slug.text}"
      o.slug.save! rescue binding.pry ;end

   def find_init search_attrs, new_attrs
      o = ::Memory.unscoped.where( short_name: search_attrs[:short_name] ).first_or_initialize( new_attrs )

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

      init_slug(o) if ! o.slug || ! o.slug.persisted?

      binding.pry if not o.valid? #or not o.persisted?
      o ;end

   def import short_name
      @short_name = short_name
      @attrs.each do |attrs|
         attrs = attrs.merge(short_name: short_name)

         (search_attrs, new_attrs) = separate_hash( parse_hash( ::Memory, attrs ) )

         begin
            o = find_init(search_attrs, new_attrs)

            o.memory_names.each { |mn| mn.name.save }
            init_slug(o) if ! o.slug&.persisted?
            o.save!
            binding.pry if ! o.slug&.persisted?

         rescue ActiveRecord::RecordNotUnique
            case $!.message
            when /: names\.|index_names_on_text_and_type_and_alphabeth_code/
               o.slug.destroy
               Kernel.puts "retry dup name"
               retry
            else
               r = false
               binding.pry
               retry if r
               raise $! ;end;end

         errs = o.errors.map do |field, message|
            StandardError.new("#{field}: #{message}") ;end

         @errors.concat(errs) ;end;end;end
