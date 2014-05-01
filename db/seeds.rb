def reports_for(agency)
    puts 'Seeding Reports...'
    Report.destroy_all

    10.times { FactoryGirl.create :report, agency: agency }
end

def agency_with_accounts
    puts 'Seeding Teammates...'
    User.destroy_all

    dispatcher = FactoryGirl.create :dispatcher, name: 'Dan', email: 'dan@example.com', password: 'password'
    20.times { FactoryGirl.create :responder, agency: dispatcher.agency }

    dispatcher.agency
end


reports_for agency_with_accounts
