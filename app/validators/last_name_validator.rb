class LastNameValidator < ActiveModel::EachValidator
   TABLE = {
      # РУ -ов/-ев/-ын-ин/-ых/-их/-ский/-цкий/-ская/-цкая/-енко/-ук/-юк/-чик/-ян/
      # -швили/-дзе/-ия
      ру: /(ов|ев|ын|ин|ых|их|ский|цкий|ская|цкая|енко|ук|юк|чик|
            ян|швили|дзе|ия)\z/x
   }

   def validate_each(record, attribute, value)
      re = TABLE[ record.language_code.to_sym ]
      if re && value !~ re
         record.errors[ attribute ] <<
         I18n.t( 'activerecord.errors.invalid_text' ) ; end ; end ; end
