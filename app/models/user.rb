class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation, :active, :user_type, :name, :last_name1, :last_name2,
                  :gender
  has_secure_password

#----------------Validations---------------
  validates_presence_of :username
  validates_uniqueness_of :username

  validates_presence_of :password, :on => :create
#--------------END Validations-------------

  def complete_name
    if self.name.blank?
      cn = self.username
    else
      cn = self.name
      unless self.last_name1.blank?
        cn = cn + ' ' +self.last_name1
        unless self.last_name2.blank?
          cn = cn + ' ' + self.last_name2
        end
      end
    end
    cn
  end

end
