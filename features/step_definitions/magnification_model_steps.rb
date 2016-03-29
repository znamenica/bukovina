То(/^.*? имеет много служебных величаний$/) do
   expect( subject ).to have_many( :service_magnifications ) ;end

То(/^.*? имеет много служб через служебные величания$/) do
   expect( subject ).to have_many( :services ).through( :service_magnifications ) ;end

