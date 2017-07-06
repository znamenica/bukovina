module Bukovina
   module Tasks
      DAYS = %w(нд пн вт ср чт пт сб)
      DAYSR = DAYS.dup.reverse
      DAYSN = DAYS.dup.rotate

      class << self
         def fix_memo_date
            memoes = Memo.where("date !~ ?", "^(\\d+\\.\\d+|[-+]\\d+|0)")
            memoes.each do |m|
               # binding.pry
               newdate =
               case m.date
               when /пасха/
                  "+0"
               when /^дн\.(\d+)\.по пасхе/ #+24
                  "+#{$1}"
               when /^дн\.(\d+)\.до пасхи/ #-24
                  "-#{$1}"
               when /^(#{DAYS.join("|")})\.(\d+)\.по пасхе/ #+70
                  daynum = DAYSN.index($1) + 1
                  days = ($2.to_i - 1) * 7 + daynum
                  "+#{days}"
               when /^(#{DAYS.join("|")})\.по пасхе/    #+7
                  daynum = DAYSN.index($1) + 1
                  "+#{daynum}"
               when /^(#{DAYS.join("|")})\.(\d+)\.до пасхи/  #-14
                  daynum = DAYSR.index($1) + 1
                  days = ($2.to_i - 1) * 7 + daynum
                  "-#{days}"
               when /^(#{DAYS.join("|")})\.до пасхи/    #-7
                  daynum = DAYSR.index($1) + 1
                  "-#{daynum}"
               when /^дн\.(\d+)\.по (\d+\.\d+)$/   #29.06%7
                  date = Time.parse("#{$2}.1970") + $1.to_i
                  date.strftime("%1d.%m")
               when /^(#{DAYS.join("|")})\.близ (\d+\.\d+)$/   #29.06%7
                  daynum = DAYS.index($1)
                  date = Time.parse("#{$2}.1970") - 4.days
                  "#{date.strftime("%1d.%m")}%#{daynum}"
               when /^(#{DAYS.join("|")})\.по (\d+\.\d+)$/   #29.06%7
                  daynum = DAYS.index($1)
                  date = Time.parse("#{$2}.1970")
                  "#{date.strftime("%1d.%m")}%#{daynum}"
               when /^(#{DAYS.join("|")})\.до (\d+\.\d+)$/  #21.06%7
                  daynum = DAYS.index($1)
                  date = Time.parse("#{$2}.1970") - 8.days
                  "#{date.strftime("%1d.%m")}%#{daynum}"
               when /^(#{DAYS.join("|")})\.(\d+)\.по (\d+\.\d+)$/   #29.06%7
                  daynum = DAYS.index($1)
                  date = Time.parse("#{$3}.1970") + ($2.to_i - 1) * 7
                  "#{date.strftime("%1d.%m")}%#{daynum}"
               when /^(#{DAYS.join("|")})\.(\d+)\.до (\d+\.\d+)$/  #21.06%7
                  daynum = DAYS.index($1)
                  date = Time.parse("#{$3}.1970") - 8.days - ($2.to_i - 1) * 7
                  "#{date.strftime("%1d.%m")}%#{daynum}"
               end
               # Kernel.puts "#{m.date} => #{newdate}" if ! newdate
               m.update(date: newdate)
            end
         end


         def add_errors f, errors
            @errors ||= {}
            @errors[ f ] ||= [ errors ].flatten ;end


         def errors
            @errors ||= {} ;end

         def import_calendary f, record
            short_name = record.keys.first
            file_short_name = f.split('/')[-2]
            if short_name != file_short_name
               add_errors(f, StandardError.new("File calendary name " +
                  "#{file_short_name} doesn't match to calendary name #{short_name}")) ;end
            data = record[ short_name ]

            parser = Bukovina::Parsers::Calendary.new
            attrs = parser.parse(data)
            if parser.errors.any?
               add_errors(f, parser.errors)
            else
               i = Bukovina::Importers::Calendary.new( attrs )
               i.import
               add_errors(f, i.errors) if i.errors.any? ;end;end

         def import_record f, record
            short_name = record.keys.first
         #         return  if short_name != 'Василий Волыньский' ####
            file_short_name = f.split('/')[-2]
            if short_name != file_short_name
               add_errors(f, StandardError.new("File short name " +
                  "#{file_short_name} doesn't match to short name #{short_name}")) ;end
            # TODO Validate memory, it will validate subfiieds itself

            data = record[ short_name ]

            parser = Bukovina::Parsers::Memory.new
            attrs = parser.parse(data)
            if parser.errors.any?
               add_errors(f, parser.errors)
            else
               Bukovina::Importers::Memory.new( attrs, short_name ).import( short_name ) ;end;end

         def import_calendaries
            Dir.glob( Bukovina.root.join('календари/**/память.*.yml') ).each do |f|
               puts "Календарь: #{f}"

               m = begin
                  YAML.load( File.open( f ) )
               rescue Psych::SyntaxError => e
                  add_errors(f, StandardError.new("#{e} for file #{f}"))
                  nil ; end

               if m
                  wd = Dir.pwd
                  Dir.chdir( File.dirname( f ) )
                  import_calendary(f, m)
                  Dir.chdir( wd ) ;end;end

            puts '-'*80
            errors.keys.each do |f|
               puts "#{f.gsub(/([ ,])/,'@\1').gsub('@','\\')}" ;end
            puts '='*80

            errors.each do |f, list|
               list.each do |e|
                  puts "@@@ #{f} -> #{e.class}:#{e.message}" ; end;end

            true; end

         def import_memories
            Dir.glob( Bukovina.root.join('памяти/**/память.*.yml') ).each.with_index do |f, i|
               puts "Память: #{i}:#{f}"

               m = begin
                  YAML.load( File.open( f ) )
               rescue Psych::SyntaxError => e
                  add_errors(f, StandardError.new("#{e} for file #{f}"))
                  nil ; end

               if m
                  wd = Dir.pwd
                  Dir.chdir( File.dirname( f ) )
                  import_record(f, m)
                  Dir.chdir( wd ) ;end;end

            puts '-'*80
            errors.keys.each do |f|
               puts "#{f.gsub(/([ ,])/,'@\1').gsub('@','\\')}" ;end
            puts '='*80

            errors.each do |f, list|
               list.each do |e|
                  puts "@@@ #{f} -> #{e.class}:#{e.message}" ; end;end

            true; end;end;end;end
