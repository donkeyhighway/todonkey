class NotesController < BaseTodosController

  private
  def set_type
    @base_todo_type = Note
  end
end