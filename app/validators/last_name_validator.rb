class LastNameValidator < ActiveModel::EachValidator
   TABLE = {
      # РУ -ов/-ев/-ын-ин/-ых/-их/-ский/-цкий/-ская/-цкая/-ный/-ная/-лый/-лая/
      # -енко/-ук/-юк/-чик/-ян/-швили/-дзе/-ия
      ру: /(ов|ев|ёв|ова|ева|ын|ин|ына|ина|ых|их|евич|ович|ский|цкий|ская|цкая|ный|ная|ний|лый|лая|ан|
            ко|енко|ук|юк|чик|
            яц|
            ян|швили|дзе|ия|ели|
            да|ва|хи|и|ун|за|.*)\z/x
   }

   def validate_each(record, attribute, value)
      re = TABLE[ record.language_code.to_sym ]
      if re && value !~ re
         record.errors[ attribute ] <<
         I18n.t( 'activerecord.errors.invalid_last_name' ) ; end ; end ; end
