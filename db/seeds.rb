def reports(agency_id)
    puts 'Seeding Reports...'
    Report.destroy_all
    3.times { FactoryGirl.create :report, agency_id: agency_id }
end

def accounts(agency_id)
    puts 'Seeding Teammates...'
    User.destroy_all

    FactoryGirl.create :dispatcher, name: 'Dispatcher Dan',
      email: 'dan@concrn.com', password: 'password', agency_id: agency_id

    7.times { FactoryGirl.create :responder,  agency_id: agency_id }
end


agency_id = FactoryGirl.create(:agency).id

reports(agency_id)
accounts(agency_id)
