module MacrosSupport
   def find_or_create model, search_attrs, attrs = {}
      model.where( search_attrs ).first_or_create attrs.merge( search_attrs )
   end
end

World(MacrosSupport)
