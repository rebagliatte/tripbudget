namespace :mock do

  desc 'Loads a whole bunch of useless records on the DB for development testing'
  task :load_all => :environment do
    traveller_1 = Traveller.create!(nickname: 'traveller-1', uid: 'donthave', name: 'Traveller 1', provider: 'twitter')
    traveller_2 = Traveller.create!(nickname: 'traveller-2', uid: 'donthave', name: 'Traveller 2', provider: 'twitter')
    traveller_3 = Traveller.create!(nickname: 'traveller-3', uid: 'donthave', name: 'Traveller 3', provider: 'twitter')
    traveller_4 = Traveller.create!(nickname: 'traveller-4', uid: 'donthave', name: 'Traveller 4', provider: 'twitter')

    basic_travellers_group = [traveller_1, traveller_2, traveller_3]

    trip_1 = Trip.create!(name: 'My Trip 1', description: 'Trip across the US!!', is_public: true, owner: traveller_1)
    trip_2 = Trip.create!(name: 'My Trip 2', description: 'Trip across Europe!!', is_public: true, owner: traveller_1)
    trip_3 = Trip.create!(name: 'My Trip 3', description: 'Trip across Uruguay!!', is_public: true, owner: traveller_4)

    destination_1 = Destination.create!(name: 'Chicago, IL', google_address: 'Chicago, IL', from_date: '2012-06-01', to_date: '2012-06-30', trip: trip_1)
    destination_2 = Destination.create!(name: 'Los Angeles, CA', google_address: 'Los Angeles, CA', from_date: '2012-07-01', to_date: '2012-07-31', trip: trip_1)
    destination_2 = Destination.create!(name: 'Las Vegas, CA', google_address: 'Las Vegas, CA', from_date: '2012-08-01', to_date: '2012-08-31', trip: trip_1)
    destination_3 = Destination.create!(name: 'Paris, France', google_address: 'Paris, France', from_date: '2012-05-01', to_date: '2012-06-01', trip: trip_2)

    expense_1 = Expense.create!(name: 'Acomodation', category: 'acomodation', destination: destination_1)
    expense_1.travellers = basic_travellers_group
    expense_1.save!
    expense_2 = Expense.create!(name: 'Food', category: 'meals', destination: destination_1)
    expense_2.travellers = basic_travellers_group
    expense_2.save!
    expense_3 = Expense.create!(name: 'Transport', category: 'transport', destination: destination_1)
    expense_3.travellers = basic_travellers_group
    expense_3.save!

    alter_1 = Alternative.create!(cost: 271, expense: expense_1, is_checked: true, link: 'google.com')
    alter_2 = Alternative.create!(cost: 1, expense: expense_2, is_checked: false, link: 'google.com')
    alter_3 = Alternative.create!(cost: 3, expense: expense_2, is_checked: true, link: 'google.com')
    alter_4 = Alternative.create!(cost: 4, expense: expense_3, is_checked: true, link: 'google.com')
    alter_5 = Alternative.create!(cost: 8, expense: expense_3, is_checked: true, link: 'google.com')
  end
end
