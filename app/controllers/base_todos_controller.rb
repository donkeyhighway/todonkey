#base controller that all 'todo' types (todo, grouping, note) inherit from
class BaseTodosController < ApplicationController
  before_filter :set_type
  before_filter :require_user

  def create
    @base_todo = @base_todo_type.new(params[:base_todo])
    current_user.base_todos << @base_todo
    respond_to do |format|
      format.xml  { render :xml => @base_todo.to_xml }
      format.json { render :json => @base_todo.as_json }
      format.html {}
    end
  end

  def index
    Rails.logger.debug("SEARCHING FOR TODOS...#{params[:search]}")
    @base_todos = current_user.send(@base_todo_type.to_s.tableize).detailed_like(params[:search]).all
    respond_to do |format|
      format.xml { render :xml => @base_todos.xml }
      format.json{ render :json => @base_todos.as_json }
      format.html{}
    end
  end

  def show

  end

  private
  def set_type
    @base_todo_type = BaseTodo
    params[:base_todo] = (params[:base_todo] || {}).merge!(:type => @base_todo_type)
  end
end