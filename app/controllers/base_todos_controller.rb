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
    group = nil
    group = unless params[:grouping].blank?
      g = Grouping.detailed_like(params[:grouping]).all
      if g.size != 1
        raise "we found multiple (#{g.size}) groupings name like '#{params[:grouping]}': #{g.map(&:detail).join(', ')}" if g.size > 1
        raise "no group found like '#{params[:grouping]}'" if g.size == 0
      end      
      g.first
    end
    @base_todos = current_user.send(@base_todo_type.to_s.tableize).detailed_like(params[:search]).in_group(group).all
    respond_to do |format|
      format.xml { render :xml => @base_todos.xml }
      format.json{ render :json => @base_todos.as_json }
      format.html{}
    end
  rescue
    respond_to do |format|
      format.xml{ render :text => $!.to_s }
      format.json{ render :json => [{:detail => "KABLAMMO! #{$!.to_s}"}] }
    end
  end

  def show

  end

  def destroy
    Rails.logger.debug("DELETE!")
    
  end

  private
  def set_type
    @base_todo_type = BaseTodo
    params[:base_todo] = (params[:base_todo] || {}).merge!(:type => @base_todo_type)
  end
end