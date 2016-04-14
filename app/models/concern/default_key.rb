module DefaultKey
   include ActiveSupport::Concern

   def default_key
      @@default_key ;end

   def default_key= key
      @@default_key = key ;end

   def has_default_key key
      self.default_key = key ;end

   def find *args
      if self.respond_to?( :default_key )
         new_args = args.flatten
         rel = self.where(self.default_key => new_args)
         if rel.size < new_args.size
            raise RecordNotFound
         else
            new_args.size > 1 && rel || rel.first ;end
      else
         super ;end ;end

   module InstanceMethods
      def default_key
         if self.class.respond_to?( :default_key )
            self.send( self.class.default_key )
         else
            raise NameError ;end ;end ;end

   def self.extended klass
      klass.include( InstanceMethods ) ;end ;end
