class PatronymicValidator < ActiveModel::EachValidator
   TABLE = {
      # РУ -ович/-овна/-евич/-евна/-ич/-ыч/-на/-ль/вар-
      ру: /((ич|ыч|на|ль)\z|\AВар)/
   }

   def validate_each(record, attribute, value)
      re = TABLE[ record.language_code.to_sym ]
      if re && value !~ re
         record.errors[ attribute ] <<
         I18n.t( 'activerecord.errors.invalid_patronymic' ) ; end ; end ; end
