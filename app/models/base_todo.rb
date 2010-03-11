class BaseTodo < ActiveRecord::Base
  set_table_name "todos"  
  belongs_to :parent, :class_name => "BaseTodo"
  has_many :children, :class_name => "BaseTodo", :foreign_key => 'parent_id'  
  belongs_to :user
  
  validates_presence_of :detail, :user_id

  scope :detailed_like, lambda{|deets|
    #there's gotta be a better way to bail on a scope when the value is 'bad'
    deets.blank? ? where("1=1") : where("detail rlike ?", deets)
  }

  scope :in_group, lambda{|group|
    group.blank? ? where("1=1") : where(:parent_id => group.id)
  }

  def childless?
    children.count == 0
  end

  def siblings
    BaseTodo.where(:parent_id => self.parent_id).all
  end

  def root?
    !self.parent_id
  end

  def child?
    !self.parent_id.nil?
  end

  def finish!(force=false)
    #recursively 'finish' all children if force is true?
  end

end
