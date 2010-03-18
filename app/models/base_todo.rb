class BaseTodo < ActiveRecord::Base
  include LinoleumScope::Scopes  

  set_table_name "todos"  
  belongs_to :parent, :class_name => "BaseTodo"
  has_many :children, :class_name => "BaseTodo", :foreign_key => 'parent_id'  
  belongs_to :user

  linoleum_scope :using => "created_at"

  validates_presence_of :detail, :user_id
  validates_uniqueness_of :detail, :scope => [:user_id, :state, :type]

  #http://github.com/pluginaweek/state_machine
  state_machine :initial => :open do
    before_transition any => :closed do|todo|
      todo.close_children!
    end
    before_transition any => :open do|todo|
      todo.open_parent!
    end
    event :close do
      transition :open => :closed
    end
    event :open do
      transition :closed => :open
    end
  end

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

  def close_children!
    #get first level children only - state_machine will implicitly handle the recursion
    BaseTodo.where(:parent_id => self.id).each do |t|
      t.close! unless t.closed?
    end
  rescue StateMachine::InvalidTransition
    Rails.logger.debug{"Invalid Transition closing children for #{self.id}"}
    false
  end

  def open_parent!
    #state_machine will implicitly handle the recursion up the parent tree
    self.parent.try(:open!) if self.parent && !self.parent.open?
  rescue StateMachine::InvalidTransition
    Rails.logger.debug{"Invalid Transition opening parent for #{self.id}"}
    false
  end

end
