#base controller that all 'todo' types (todo, grouping, note) inherit from
class BaseTodosController < ApplicationController
  before_filter :set_type
  before_filter :require_user

  def create
    #if I've got a grouping, find or create it, as long as there's only one to find
    @grouping = begin
      locate_grouping
    rescue Grouping::NoneFound => nf
      #create the group
      Grouping.new(:detail => params[:grouping], :user_id => current_user.id)
    end
    
    @grouping.save! if @grouping && @grouping.new_record?
    BaseTodo.transaction do
      @base_todo = @base_todo_type.new(params[:base_todo])
      @base_todo.parent_id = @grouping && @grouping.id
      current_user.base_todos << @base_todo      
    end

    respond_to do |format|
      format.xml  { render :xml => @base_todo.to_xml }
      format.json { render :json => @base_todo.as_json }
      format.html {}
    end
  rescue
    Rails.logger.error("Exception creating todo: #{$!.to_s}")
    flash[:error] = $!.to_s
    respond_to do |format|
      format.xml{ render :text => $!.to_s }
      format.json{ render :json => {:detail => "KABLAMMO! #{$!.to_s}"} }
      format.html {}
    end
  end

  def index
    @grouping = locate_grouping
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

  def locate_grouping
    unless params[:grouping].blank?
      g = params[:grouping].to_i != 0 ? [Grouping.find(params[:grouping])] : Grouping.detailed_like(params[:grouping]).all

      raise Grouping::MultipleFound.new("we found multiple (#{g.size}) groupings named like '#{params[:grouping]}': #{g.map{|grouping| "#{grouping.detail}[#{grouping.id}]"}.join(', ')}") if g.size > 1
      raise Grouping::NoneFound.new("no group found like '#{params[:grouping]}'") if g.size == 0

      g.first
    end
  end

end