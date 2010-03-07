class Todo < BaseTodo  
  has_many :notes, :foreign_key => 'parent_id'
  
end
