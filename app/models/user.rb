class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation, :active, :user_type, :name, :last_name1, :last_name2,
                  :gender
  has_secure_password

#----------------Validations---------------
  validates_presence_of :username
  validates_uniqueness_of :username

  validates_presence_of :password, :on => :create
#--------------END Validations-------------
end
