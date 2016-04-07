module Language
   include ActiveSupport::Concern
         
   LANGUAGE_TREE = {
      сс: :сс,
      сц: :сц,
      цс: [ :цс, :ро, :ру, :цр ],
      ру: [ :ру, :ро ],
      ук: :ук,
      бл: :бл,
      мк: :мк,
      сх: :ср,
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
      рм: [ :рм, :цу, :цр ],
      гр: :гр,
      ла: :ла,
      ит: :ит,
      фр: :фр,
      ис: :ис,
      не: :не,
      ир: :ир,
      си: :си,
      ан: :ан,
      са: :са,
   }

   ALPHABETH_LIST = LANGUAGE_TREE.values.flatten.uniq

   OPTIONS = [ :novalidate, :on ]

   def has_alphabeth options = {}
      ( OPTIONS & options.keys ).each do |o|
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
         else
            raise "Target of kind #{o.class} is unsupported" ;end ;end
         .flatten.map { |x| [ x.keys.first, x.values.first ] }.to_h

      on.each do |target, options|
         self.class_eval <<-RUBY
            validates :#{target}, alphabeth: #{options.inspect}
         RUBY
         end ;end

   def setup_novalidate novalidate
      if ! novalidate
         self.class_eval <<-RUBY
            validates :language_code, inclusion:
               { in: Language::LANGUAGE_TREE.keys }
            validates :alphaneth_code, inclusion:
               { in: Language::ALPHABETH_LIST }
            RUBY
            end ;end ;end
