То(/^будет создана модель (#{kinds_re}) с аттрибутами:$/) do |kind, table|
   joins = []
   replaces = {}
   attrs = table.rows_hash.map do |(attr, value)|
      if /^\*(?<newvalue>.*)$/ =~ value
         attrs = attr.split('.')

         new_attrs = attrs[0..-2].map( &:to_sym )
         joins.concat( new_attrs )
         replaces.merge!( new_attrs.map do |a|
            base = model_of( kind ).reflections[ a.to_s ].class_name.tableize
            [ a.to_s, base ]
            end
         .to_h )

         model = attrs.last.camelize.constantize

         sample = model.where( base_field( attrs.last ) => newvalue ).first
         [ "#{attr}_id", sample.id ]
      else
         [ attr, value ] ;end ;end.to_h

   relation = model_of( kind ).joins( joins ).where( attrs )
   expect( relation ).to_not be_empty ;end
