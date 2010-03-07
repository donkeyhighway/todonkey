class TodosController < BaseTodosController
  #defaults :resource_class => Todo, :collection_name => 'base_todos', :instance_name => 'base_todo'
  before_filter :set_type
  #respond_to :html, :xml, :json


  protected
  def collection
    @base_todos ||= BaseTodo.where(:type => @base_todo_type.to_s, :parent_id => nil).order("created_at DESC").all
  end

  def begin_of_association_chain
    signed_user
  end

  private
  def set_type
    @base_todo_type = Todo
  end
end
