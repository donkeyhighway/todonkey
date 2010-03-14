#base controller that all 'todo' types (todo, grouping, note) inherit from
class BaseTodosController < ApplicationController
  before_filter :set_type
  before_filter :require_user
  #before_filter :locate_grouping, :only => [:create, :index]

  def locate_grouping
    
  end

  def create
    #if I've got a grouping, find or create it, as long as there's only one to find

    @base_todo = @base_todo_type.new(params[:base_todo])
    current_user.base_todos << @base_todo
    respond_to do |format|
      format.xml  { render :xml => @base_todo.to_xml }
      format.json { render :json => @base_todo.as_json }
      format.html {}
    end
  end

  def index
    @grouping = unless params[:grouping].blank?
      g = Grouping.detailed_like(params[:grouping]).all

      raise "we found multiple (#{g.size}) groupings named like '#{params[:grouping]}': #{g.map{|grouping| "#{grouping.detail}[#{grouping.id}]"}.join(', ')}" if g.size > 1
      raise "no group found like '#{params[:grouping]}'" if g.size == 0

      g.first
    end
    @base_todos = @base_todo_type.where(:user_id => current_user.id).detailed_like(params[:search]).in_group(@grouping)

    #handle 'yesterday', 'today' options
    @base_todos = @base_todos.send(params[:for].downcase.to_sym) if Grouping::RESERVED_GROUPING.include?(params[:for].try(:downcase))
    
    respond_to do |format|
      format.xml { render :xml => @base_todos.to_xml }
      format.json{ render :json => @base_todos.all.as_json }
      format.html{  }
    end
  rescue
    Rails.logger.error("Exception getting index: #{$!.to_s}")
    flash[:error] = $!.to_s
    respond_to do |format|
      format.xml{ render :text => $!.to_s }
      format.json{ render :json => [{:detail => "KABLAMMO! #{$!.to_s}"}] }
      format.html {}
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