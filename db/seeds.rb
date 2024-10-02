# frozen_string_literal: true

Studio.create(name: 'studio1')
Studio.create(name: 'studio2')

studio1 = Studio.find_by(name: 'studio1')
studio2 = Studio.find_by(name: 'studio2')

studio1.stays.create(start_date: '2024-01-01', end_date: '2024-01-08')
studio1.stays.create(start_date: '2024-01-16', end_date: '2024-01-24')

studio2.stays.create(start_date: '2024-01-05', end_date: '2024-01-10')
studio2.stays.create(start_date: '2024-01-15', end_date: '2024-01-20')
studio2.stays.create(start_date: '2024-01-21', end_date: '2024-01-25')
