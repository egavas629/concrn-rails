def reports
    puts 'Seeding Reports...'
    Report.destroy_all
    10.times { FactoryGirl.create :report }
end

def accounts
    puts 'Seeding Teammates...'
    User.destroy_all

    dispatcher = FactoryGirl.create :dispatcher, name: 'Dan', email: 'dan@example.com', password: 'password'
    20.times { FactoryGirl.create :responder }
end


reports
accounts
