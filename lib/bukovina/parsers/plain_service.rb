class Bukovina::Parsers::PlainService
   attr_reader :errors

   Parsers = Bukovina::Parsers

   def parse line
      res =
      if line.is_a?( String )
         { text: line }
      else
         @errors << Parsers::BukovinaInvalidClass.new( "Invalid class " +
            "#{line.class} for Name line '#{line}'" ) ; end

      @errors.empty? && res || nil ; end

   def initialize
      @errors = [] ; end ; end
