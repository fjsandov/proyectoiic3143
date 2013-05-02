class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation, :active
  has_secure_password

#----------------Validations---------------
  validates_presence_of :username
  validates_uniqueness_of :username

  validates_presence_of :password, :on => :create
#--------------END Validations-------------
end
