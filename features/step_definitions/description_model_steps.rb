То(/^свойство "([^"]*)" модели есть отношение$/) do |prop|
   expect( subject ).to belong_to( prop ) ; end

То(/^получим ошибку удвоения попытавшись создать новое описание с полями:$/) do |table|
   t = table.rows_hash.deep_dup
   t.delete("describable:memory")
   create( Description, table.rows_hash )
   expect{ create( Description, table.rows_hash ) }
      .to raise_exception( ActiveRecord::RecordNotUnique ) ; end
