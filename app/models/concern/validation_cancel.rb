module ValidationCancel
   def cancel_validates *attributes
      this = self
      attributes.select {|v| Symbol === v }.each do |attr|
         self._validate_callbacks.select do |callback|
            callback.raw_filter.try( :attributes ) == [ attr ] ;end
         .each do |vc|
            ifs = vc.instance_variable_get( :@if )
            ifs << proc { ! self.is_a?( this ) } ;end ;end ;end ;end
