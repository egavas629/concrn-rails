def reports
    puts 'Seeding Reports...'
    3.times { FactoryGirl.create :report }
end

def accounts
    puts 'Seeding Teammates...'
    FactoryGirl.create :dispatcher, name: 'Yirtth Venes', email: 'yirtth@concrn.com', password: 'streetmom'
    7.times { FactoryGirl.create :responder }
end

def clients
    puts 'Seeding Clients...'
    10.times { FactoryGirl.create :client }
end

reports
accounts
clients
