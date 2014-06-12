def reports
    puts 'Seeding Reports...'
    Report.destroy_all
    3.times { FactoryGirl.create :report }
end

def accounts
    puts 'Seeding Teammates...'
    User.destroy_all

    dispatcher = FactoryGirl.create :dispatcher, name: 'Dispatcher Dan', email: 'dan@concrn.com', password: 'password'
    7.times { FactoryGirl.create :responder }
end


reports
accounts
