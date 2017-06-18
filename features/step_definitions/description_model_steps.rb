То(/^свойство "([^"]*)" модели есть отношение$/) do |prop|
   expect( subject ).to belong_to( prop ) ; end

То(/^получим ошибку удвоения попытавшись создать новое описание с полями:$/) do |table|
   attrs = table.rows_hash.map { |attr, value| [ attr, YAML.load(value) ] }.to_h
   create( :description, attrs )
   expect{ create( :description, attrs ) }
      .to raise_exception( ActiveRecord::RecordNotUnique ) ; end
