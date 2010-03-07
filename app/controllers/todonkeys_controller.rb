class TodonkeysController < InheritedResources::Base
  respond_to :html, :xml, :json
  defaults :resource_class => BaseTodo, :collection_name => 'todonkeys', :instance_name => 'todonkey'

end
