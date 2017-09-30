module Language
   include ActiveSupport::Concern
         
   # :nodoc:
   LANGUAGE_TREE = {
      ру: %i(рп ру),
      цс: %i(цс рп ру цр),
      сс: :сс,
      сц: :сц,
      ук: :ук,
      бл: :бл,
      мк: :мк,
      сх: %i(ср хр),
      со: :со,
      бг: :бг,
      чх: :чх,
      сл: :сл,
      по: :по,
      кш: :кш,
      вл: :вл,
      нл: :нл,
      ар: :ар,
      ив: :ив,
      рм: %i(рм цу цр),
      гр: :гр,
      ла: :ла,
      ит: :ит,
      фр: :фр,
      ис: :ис,
      не: :не,
      ир: :ир,
      си: :си,
      ан: %i(ан са ра)
   }

   # :nodoc:
   OPTIONS = %i(novalidate on)

   # +language_list+ returns list of available languages.
   #
   # Example:
   #
   #     validates :language_code, inclusion: { in: Language.language_list }
   #
   def self.language_list
      list = Language::LANGUAGE_TREE.keys
      list.concat( list.map( &:to_s ) ) ;end

   # +alphabeth_list+ returns list of available languages.
   #
   def self.alphabeth_list
      Language::LANGUAGE_TREE.values.flatten.uniq ;end

   # +alphabeth_list_for+ returns list of available alphabeths for the specified
   # language code.
   #
   # Example:
   #
   #     validates :alphabeth_code, inclusion: { in: proc { |l|
   #        Language.alphabeth_list_for( l.language_code ) } } ; end
   #
   def self.alphabeth_list_for language_code
      [ Language::LANGUAGE_TREE[ language_code.to_s.to_sym ] ].flatten
         .map( &:to_s ) ;end

   # +language_list_for+ returns the language list for the specified alphabeth
   # code.
   #
   # Example:
   #
   #     validates :language_code, inclusion: { in: proc { |l|
   #        Language.language_list_for( l.alphabeth_code ) } } ; end
   #
   def self.language_list_for alphabeth_code
      language_codes =
      Language::LANGUAGE_TREE.invert.map do |(alphs, lang)|
         [ alphs ].flatten.map do |a|
            [a, lang] ;end;end
      .flatten(1).reduce({}) do |h, (alph, lang)|
         case h[alph]
         when NilClass
            h[alph] = lang
         when Array
            h[alph] << lang
         else
            h[alph] = [ h[alph], lang ] ;end
         h ;end
      .[](alphabeth_code.to_sym)
   
      [ language_codes ].flatten.compact.map( &:to_s ) ;end

   # +has_alphabeth+ sets up alphabeth feature on a column or itself model,
   # i.e. generally +alphabeth_code+, and +language_code+ fields to match text
   # of the specified columns if any.
   #
   # Examples:
   #
   #     has_alphabeth on: name: true
   #     has_alphabeth on: { text: [:nosyntax, allow: " ‑" ] }
   #     has_alphabeth on: [ :name, :text ]
   #     has_alphabeth novalidate: true
   #
   def has_alphabeth options = {}
      OPTIONS.each do |o|
         self.send( "setup_#{o}", options[ o ] ) ;end ;end

   protected

   # +setup_on+ accepts options :on for validation on a specified field
   #
   # Examples:
   #
   #     has_alphabeth on: name: true
   #     has_alphabeth on: { text: [:nosyntax, allow: " ‑" ] }
   #     has_alphabeth on: [ :name, :text ]
   #
   def setup_on option_on
      on = [ option_on ].map do |o|
         case o
         when Hash
            o.map { |(k, v)| { k => v } }
         when String, Symbol
            { o => true }
         when Array
            o.map { |x| { x => true } }
         when NilClass
            []
         else
            raise "Target of kind #{o.class} is unsupported" ;end ;end
         .flatten.map { |x| [ x.keys.first, x.values.first ] }.to_h

      on.each do |target, options|
         self.class_eval <<-RUBY
            validates :#{target}, alphabeth: #{options.inspect}
         RUBY
         end ;end

   # +setup_novalidate+ accepts boolean option :novalidate to skip validation on
   # +:language_code+, and +:alphabeth_code+ fields.
   #
   # Examples:
   #
   #     has_alphabeth novalidate: true
   #
   def setup_novalidate novalidate
      if ! novalidate
         self.class_eval <<-RUBY
            validates :language_code, inclusion:
               { in: Language.language_list }
            validates :alphabeth_code, inclusion:
               { in: proc { |l|
                  Language.alphabeth_list_for( l.language_code ) } }
            RUBY
            end ;end ;end
