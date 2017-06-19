module Bukovina
   module Tasks
      class << self
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
