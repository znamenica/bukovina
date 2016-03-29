Допустим(/^есть обработанные данные службы:$/) do |string|
   @importer = Bukovina::Importers::Service.new( YAML.load( string ) ) ; end

То(/^будет создана модель (.*?) с аттрибутами:$/) do |mname, table|
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
      binding.pry

   expect( model_of( mname ).joins(joins).where( attrs ).count ).to be_eql( 1 ) ;end
