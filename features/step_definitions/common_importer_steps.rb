То(/^будет создана модель (#{kinds_re}) с аттрибутами:$/) do |kind, table|
   joins = []
   attrs = table.rows_hash.map do |(attr, value)|
      if /^\*(?<newvalue>.*)$/ =~ value
         attrs = attr.split('.')
         joins.concat( attrs[0..-2].map( &:to_sym ) )
         model = attrs.last.camelize.constantize

         sample = model.where( base_field( attrs.last ) => newvalue ).first
         [ "#{attr}_id", sample.id ]
      else
         [ attr, value ] ;end ;end.to_h

   relation = model_of( kind ).joins( joins ).where( attrs )
   expect( relation ).to_not be_empty ;end
