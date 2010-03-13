class Grouping < BaseTodo
  RESERVED_GROUPING = %w(today)
  has_many :todos, :class_name => "Todo", :foreign_key => 'parent_id'
  has_many :notes, :class_name => "Note", :foreign_key => 'parent_id'  
end
