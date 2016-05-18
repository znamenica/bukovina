То(/^обращение к свойству "([^"]*)" отправляется к событию$/) do |prop|
   expect( subject ).to delegate_method( prop.to_sym ).to(:event) ;end
