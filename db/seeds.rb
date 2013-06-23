# -*- encoding : utf-8 -*-

u1 = User.create(username: 'admin', password: 'admin', password_confirmation: 'admin', gender: 'F', active: true,
                 name: 'Maria Eugenia', last_name1: 'Sánchez', user_type: 'admin')
u2 = User.create(username: 'cord1', password: 'cord1', password_confirmation: 'cord1', gender: 'F', active: true,
                 name: 'Coordinador de Test', user_type: 'coordinator')

s1 = Sector.create(name: 'Maternidad', zone: 'Crítica')
s2 = Sector.create(name: 'Pabellón', zone: 'Crítica')
s3 = Sector.create(name: 'Pediatría', zone: 'Crítica')
s4 = Sector.create(name: 'Recepción', zone: 'Normal')

r1 = Room.create(name: 'M01', floor: 2, status: 'free', sector_id: s1.id)
r2 = Room.create(name: 'M02', floor: 2, status: 'free', sector_id: s1.id)
r3 = Room.create(name: 'M03', floor: 2, status: 'free', sector_id: s1.id)
r4 = Room.create(name: 'M04', floor: 2, status: 'free', sector_id: s1.id)
r5 = Room.create(name: 'M05', floor: 2, status: 'free', sector_id: s1.id)
r6 = Room.create(name: 'Pab05', floor: 2, status: 'free', sector_id: s2.id)
r7 = Room.create(name: 'Ped01', floor: 3, status: 'free', sector_id: s3.id)
r8 = Room.create(name: 'R01', floor: 1, status: 'free', sector_id: s4.id)
r9 = Room.create(name: 'R02', floor: 1, status: 'free', sector_id: s4.id)
r10 = Room.create(name: 'R03', floor: 1, status: 'free', sector_id: s4.id)
r11 = Room.create(name: 'R04', floor: 1, status: 'free', sector_id: s4.id)

oc1 = Occupation.create(name: 'Auxiliar', admin_leave_days: 3, vacation_days: 5)
oc2 = Occupation.create(name: 'Supervisor', admin_leave_days: 5, vacation_days: 10)

e1 = Employee.create(name: 'Francisco Javier', last_name1: 'Sandoval',
                     last_name2: 'Aburto', gender: 'M', occupation: oc1)
e2 = Employee.create(name: 'Pablo', last_name1: 'Cruz', gender: 'M', occupation: oc1)
e3 = Employee.create(name: 'Giovanni', last_name1: 'De Lucca', gender: 'M', occupation: oc1)
e4 = Employee.create(name: 'Larry', last_name1: 'Capizza', gender: 'M', occupation: oc2)

sh1 = Shift.create(name: 'Turno mañana lun-vie',
                   monday: true, tuesday: true, wednesday: true, thursday: true, friday: true,
                   start_time: Time.new(2013, nil, nil, 6, 0),
                   end_time: Time.new(2013, nil, nil, 12, 0))
sh2 = Shift.create(name: 'Turno tarde lun-dom',
                   monday: true, tuesday: true, wednesday: true, thursday: true, friday: true, saturday: true, sunday: true,
                   start_time: Time.new(2013, nil, nil, 12, 0),
                   end_time: Time.new(2013, nil, nil, 18, 0))

e1.shifts << sh1
e2.shifts << sh1
e3.shifts << sh2