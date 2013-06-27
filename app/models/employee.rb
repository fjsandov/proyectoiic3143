# -*- encoding : utf-8 -*-
class Employee < ActiveRecord::Base
  attr_accessible :birth_date, :children, :education_level, :equipment_date, :gender, :joined_at,
                  :last_name1, :last_name2, :marital_status, :name, :religion, :spouse_name, :spouse_occupation,
                  :training, :uniform_date, :occupation, :occupation_id

  belongs_to :occupation
  has_and_belongs_to_many :terminal_cleanups
  has_and_belongs_to_many :cleanup_requests
  has_many :assistances
  has_and_belongs_to_many :shifts
  has_many :vacations

  def self.get_list
    Employee.order(:last_name1)
  end

  def self.search(search)
    if search
      where('employees.name LIKE ? or employees.last_name1 LIKE ? or employees.last_name2 LIKE ?',
            "%#{search}%","%#{search}%","%#{search}%")
    else
      scoped
    end
  end

  def self.on_turn_employees  #TODO: Que en verdad sean los que estan de turno
     Employee.all
  end

  def self.on_turn_employees_for_select
    self.on_turn_employees.collect do |employee|
      [employee.complete_name, employee.id]
    end
  end

  def self.occupation_options
    Occupation.all.collect do |occupation|
      [occupation.name, occupation.id]
    end
  end

  def self.marital_status_options
    [['Soltero/a','single'],['Casado/a','married'], ['Divorciado/a','divorced'], ['Viudo/a','widower']]
  end

  def self.education_level_options
    [['Básica','elementary_school'],['Media','high_school'],['Técnica','technical'],['Universitaria','college'],['Otro','other']]
  end

#----------------------métodos de instancia----------------------
  def complete_name
    cn = self.name
    unless self.last_name1.blank?
      cn = cn + ' ' +self.last_name1
      unless self.last_name2.blank?
        cn = cn + ' ' + self.last_name2
      end
    end
    cn
  end

  def get_occupation
    aux = self.occupation
    aux.blank? ? 'Ninguna' : aux.name
  end

  def get_status
    #TODO: que diga si el empleado esta de vacaciones, permiso, en turno o atendiendo limpieza
    if is_on_vacation?
      is_on_vacation_str
    else
      'Activo'
    end
  end

  def get_work_history
    self.assistances.order('date DESC')
  end

  def get_cleaning_history
    aux = CleanupRequest.joins(:employees).where('employees.id = ? and
                              cleanup_requests.status = ?',self.id,'finished')
    aux.order('requested_at DESC')
  end

  # Diccionario con los distintos dias de vacaciones que ha tomado desde 01/Enero
  def get_vacation_days
    vacations = self.vacations.where('start_date > ?', Time.current.at_beginning_of_year)

    totals = {'vacation' => 0, 'administrative' => 0, 'license' => 0}
    vacations.each do |v|
      # start_date y end_date son inclusivos
      totals[v.vacation_type] += ((v.end_date.tomorrow.at_beginning_of_day - v.start_date.at_beginning_of_day) / 1.day).to_i
    end
    totals
  end

  # Retorna un bool indicando si el empleado esta en vacaciones, con permiso, o con licencia.
  def is_on_vacation?(date=Time.current)
    Vacation.is_on_vacation?(self.id, date)
  end

  # Idem a is_on_vacation?, pero retorna el string con el tipo de vacacion.
  def is_on_vacation_str(date=Time.current)
    Vacation.is_on_vacation_str(self.id, date)
  end
end
