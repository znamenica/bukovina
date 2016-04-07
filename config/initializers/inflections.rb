ActiveSupport::Inflector.inflections do |inflect|
   inflect.plural /^(.*)o$/i, '\1oes'
   inflect.singular /^(.*)oes/i, '\1o' ;end
