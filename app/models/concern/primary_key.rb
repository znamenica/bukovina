module PrimaryKeyAdvanced
   include ActiveSupport::Concern

   def has_primary_key key
      self.primary_key = key
   end

   module InstanceMethods
      def id
         sync_with_transaction_state
         read_attribute(:id)
      end

      def id= value
         write_attribute(:id, value)
      end
   end
end
