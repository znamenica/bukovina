То(/^будет создана модель (#{kinds_re}) с аттрибутами:$/) do |kind, table|
   joins = []
   attrs = table.rows_hash.map do |(attr, value)|
      if /^\*(?<match_value>.*)$/ =~ value
         attrs = attr.split('.')

         new_attrs = attrs[0..-2].map( &:to_sym )
         joins.concat( new_attrs )
         model_name = model_of( kind ).to_s
         new_attrs = new_attrs.map do |a|
            model_name = model_of( kind ).reflections[ a.to_s ].class_name
            table = model_name.tableize
            [ a.to_s, table ]
            end
         .to_h.values

         new_attrs << ( model_name.constantize.try( :default_key ) ||
            "#{attrs[ -1 ]}_id" )

         model = attrs.last.camelize.constantize

         sample = model.where( base_field( attrs.last ) => match_value ).first
         new_value = /id$/ =~ new_attrs.last && sample.id ||
            sample.try( :default_key ) || sample
         [ new_attrs.join( '.' ), new_value ]
      else
         [ attr, value ] ;end ;end.to_h

   relation = model_of( kind ).joins( joins ).where( attrs )
   expect( relation.size ).to be_eql( 1 ) ;end
