То(/^служба имеет много песнопений через служебные песнопения$/) do
   expect( subject ).to have_many( :chants ).through( :service_chants ) ;end

То(/^.*? относится к информируемому$/) do
   expect( subject ).to belong_to( :info ) ;end

То(/^.*? относится к памяти$/) do
   expect( subject ).to belong_to( :memory ) ;end
