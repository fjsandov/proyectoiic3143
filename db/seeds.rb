# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u1 = User.create(username: 'admin', password: 'admin', password_confirmation: 'admin', gender: 'F', active: true, name: 'Maria Eugenia', last_name1: 'Sanchez')
u2 = User.create(username: 'cord1', password: 'cord1', password_confirmation: 'cord1', gender: 'F', active: true, name: 'Coordinador de Test')

s1 = Sector.create(name: 'Maternidad',zone: 'Critica')
s2 = Sector.create(name: 'Pabellon',zone: 'Critica')
s3 = Sector.create(name: 'Pediatria',zone: 'Critica')
s4 = Sector.create(name: 'Recepcion',zone: 'Normal')

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

e1 = Employee.create(name: 'Francisco Javier', last_name1: 'Sandoval', last_name2: 'Aburto')
e2 = Employee.create(name: 'Pablo', last_name1: 'Cruz')
e3 = Employee.create(name: 'Giovanni', last_name1: 'De Lucca')
e4 = Employee.create(name: 'Larry', last_name1: 'Capizza')


