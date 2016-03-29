module LanguageCode
   include ActiveSupport::Concern

   OPTIONS = [ :novalidate, :on ]

   def has_language options = {}
      self.class_eval <<-RUBY
         enum language_code: [ :цс, :ру, :ср, :гр, :ан, :ла, :чх, :ир, :си,
            :бг, :ит, :ар, :ив, :рм, :са, :ис, :фр, :не, :ук ]
         RUBY

      ( OPTIONS & options.keys ).each do |o|
         self.send( "setup_#{o}", options[ o ] ) ;end ;end

   protected

   # +setup_on+ accepts options :on for validation on a specified field
   #
   # Examples:
   #
   #     has_language on: name: true
   #     has_language on: { text: [:nosyntax, allow: " ‑" ] }
   #     has_language on: [ :name, :text ]
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
            validates :#{target}, text: #{options.inspect}
         RUBY
         end ;end

   def setup_novalidate novalidate
      if ! novalidate
         self.class_eval <<-RUBY
            validates :language_code, inclusion: { in: self.language_codes }
            RUBY
            end ;end ;end
