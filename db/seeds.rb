def agencies
  puts 'Seeding Agency...'
  Agency.destroy_all
  return FactoryGirl.create(:agency)
end

def reports(agency_id)
    puts 'Seeding Reports...'
    3.times { FactoryGirl.create :report, agency_id: agency_id }
end

def accounts(agency_id)
    puts 'Seeding Teammates...'
    FactoryGirl.create :dispatcher, name: 'Dispatcher Dan',
      email: 'doug@concrn.com', password: 'streetmom', agency_id: agency_id

    7.times { FactoryGirl.create :responder,  agency_id: agency_id }
end

agency_id = agencies.id
# reports(agency_id)
# accounts(agency_id)
