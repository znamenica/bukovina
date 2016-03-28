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

   def setup_on option_on
      on = [ option_on ].flatten.compact
      on.each do |target|
         if is_symbol?( target )
            self.class_eval <<-RUBY
               validates :#{target}, text: true
            RUBY
         else
            raise "Target of kind #{target.class} is unsupported"
            end ;end ;end

   def setup_novalidate novalidate
      if ! novalidate
         self.class_eval <<-RUBY
            validates :language_code, inclusion: { in: self.language_codes }
            RUBY
            end ;end

   def is_symbol? object
      [ Symbol, String ].any? { |kind| kind === object } ;end ;end
