# -*- encoding : utf-8 -*-
class TerminalCleanup < ActiveRecord::Base
  attr_accessible :comments, :interval, :start_date, :end_date, :room_id, :sector_id

  belongs_to :sector
  belongs_to :room
  has_many :terminal_cleanup_instances

  validates_presence_of :interval, :start_date
  validate :validate_room_or_sector_is_present

  def validate_room_or_sector_is_present
    if room_id.blank? && sector_id.blank?
      errors[:base] << 'Se debe seleccionar un sector o una sala.'
    end
  end

  def name
    room ? room.name : 'Sector ' + sector.name
  end

  def self.get_today_instances
    today = Date.today.to_time_in_current_zone
    self.get_instances(today, today + 1.day)
  end

  # Retorna un arreglo de diccionarios con info simple sobre cada aseo terminal agendado
  # para la fecha dada.
  def self.get_instances(start_date, end_date)
    events = []

    TerminalCleanup.find_each do |tc|
      rule_date = tc.start_date
      # Primera fecha debe ser >= start_date
      while rule_date < start_date
        rule_date += tc.interval.days  # TODO: calc. iterativo no es eficiente
      end

      # Cachear tci para evitar demasiadas consultas
      tci_collection = tc.terminal_cleanup_instances.where('(original_date BETWEEN ? AND ?) OR ' +
                                                           '(instance_date BETWEEN ? AND ?) OR ' +
                                                           'instance_date IS NULL',
                                                           start_date, end_date, start_date, end_date)

      # capturar los instances que fueron considerados por siguiente while (Si comienzo con arreglo vacio Rails se marea)
      tci_returned_ids = [0]

      rule_end_date = (tc.end_date or end_date)
      while rule_date <= rule_end_date
        # check terminal_cleanup_instances
        tci = tci_collection.find { |tc_instance| tc_instance.original_date == rule_date }
        if tci
          tci_returned_ids << tci.id
          if tci.instance_date && tci.instance_date <= end_date
            # generado a partir de una instancia
            events << {
                :eventType => 'instance',
                :id => tci.id,
                :start => tci.instance_date,
                :title => tci.terminal_cleanup.name,
            }
          else
            # es una excepcion de aseo
          end
        else
          # generado a partir de la regla
          events << {
              :eventType => 'rule',
              :id => tc.id,
              :start => rule_date,
              :title => tc.name,
          }
        end

        rule_date += tc.interval.days
      end

      # revisar los ids que no fueron considerados en el while anterior
      tci_collection.each do |tci|
        if (not tci.id.in? tci_returned_ids) && tci.instance_date && tci.instance_date.between?(start_date, end_date)
          # generado a partir de una instancia
          events << {
              :eventType => 'instance',
              :id => tci.id,
              :start => tci.instance_date,
              :title => tci.terminal_cleanup.name,
          }
        end
      end
    end # end find_each

    return events
  end

end
