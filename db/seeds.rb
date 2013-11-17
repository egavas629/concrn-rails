def create_reports
    Report.destroy_all

    15.times do
      address = Faker::Address
      Report.create({
        name: Faker::Name.name,
        phone: Faker::PhoneNumber.cell_phone,
        lat: 37.920556 + (rand() * (rand() > 0.5 ? -1 : 1)),
        long: 122.416667 + (rand() * (rand() > 0.5 ? -1 : 1)),
        address: address.street_address,
        age: "Young Adult",
        gender: "Male",
        race: "Caucasian",
        nature: Faker::Company.bs
        })
    end
end

def create_accounts
    User.destroy_all
    User.create!(email: 'dan@example.com', role: 'dispatcher', password: 'password')
end

def create_responders
    Responder.destroy_all
    15.times do
      Responder.create!(
        name: Faker::Name.name,
        phone: Faker::PhoneNumber.cell_phone,
        email: Faker::Internet.email,
        password: "password",
        password_confirmation: "password"
      )
    end

end
create_reports
create_accounts
create_responders
