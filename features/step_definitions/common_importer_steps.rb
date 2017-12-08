Если(/^импортируем их$/) do
   @importer.import ; end

То(/модель (#{kinds_re}) с аттрибутами:$/) do |kind, table|
   attrs, joins = make_attrs_for( table.rows_hash, model_of( kind ) )
   relation = model_of( kind ).joins( joins ).where( attrs )
   binding.pry if ENV['DEBUG']
   expect( relation.size ).to be_eql( 1 ) ;end
