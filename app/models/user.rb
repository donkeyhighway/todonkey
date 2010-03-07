class User < ActiveRecord::Base
  has_many :groupings
  has_many :todos
  has_many :notes
  has_many :base_todos

  acts_as_authentic do |c|
    c.login_field = 'login'    
  end

end