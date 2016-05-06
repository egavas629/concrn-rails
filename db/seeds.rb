
ActiveRecord::Base.transaction do
  puts 'Seeding Reports...'
  10.times { FactoryGirl.create :report }

  puts 'Seeding Teammates...'
  FactoryGirl.create :dispatcher, name: 'Dan Dan', email: 'dan@concrn.org', password: 'streetmom'
  3.times { FactoryGirl.create :responder }

  puts 'Seeding Clients...'
  3.times { FactoryGirl.create :client }
end