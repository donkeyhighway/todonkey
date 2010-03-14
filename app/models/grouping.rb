class Grouping < BaseTodo
  class MultipleFound < StandardError; end
  class NoneFound < StandardError; end
  
  RESERVED_GROUPING = %w(today yesterday the_other_day)
  has_many :todos, :class_name => "Todo", :foreign_key => 'parent_id'
  has_many :notes, :class_name => "Note", :foreign_key => 'parent_id'  
end
