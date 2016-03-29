То(/^.*? имеет много служб через служебные песнопения$/) do
   expect( subject ).to have_many( :services ).through( :service_chants ) ;end
