class Note < BaseTodo  
  has_many :todos, :foreign_key => 'parent_id'
end
