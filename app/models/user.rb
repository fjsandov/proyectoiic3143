# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation, :active, :user_type,
                  :name, :last_name1, :last_name2, :gender
  has_secure_password

#----------------Validations---------------
  validates_presence_of :username, :user_type, :gender
  validates_uniqueness_of :username

  validates_presence_of :password, :on => :create
  validate :first_user_is_admin

  def first_user_is_admin
    if self.id == 1 && self.user_type != 'admin'
      errors[:base] << 'Este usuario es el dueño del sistema por lo que es administrador por defecto y no puede perder ese privilegio.'
    end
  end
#--------------END Validations-------------

  def self.user_type_options
    [['Administrador/a','admin'],['Coordinador/a','coordinator'], ['Solo Lectura', 'read-only']]
  end

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

  def admin?
    self.user_type == 'admin'
  end

  def read_only?
    self.user_type == 'read-only'
  end

  def get_user_type_str
    str = ''
    case self.user_type
       when 'admin' then str = 'Administrador'
       when 'coordinator' then str = 'Coordinador'
       when 'read-only' then str = 'Solo Lectura'
       else return 'ERROR'
    end

    if self.gender == 'F' && (self.user_type =='admin' || self.user_type == 'coordinator')
      str += 'a'
    end
    str
  end
end
