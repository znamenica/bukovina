module ValidationCancel
   def cancels_validation *validations
      validations.select {|v| Symbol === v }.each do |v|
         self._validators.delete( v ) ;end ;end ;end
