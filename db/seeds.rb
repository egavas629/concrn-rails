def create_reports
    Report.destroy_all

    15.times do
      Report.create({
        name: Faker::Name.name,
        phone: Faker::PhoneNumber.cell_phone,
        lat: rand(200),
        long: rand(200),
        nature: Faker::Company.bs
        })
    end
end

def create_accounts
    User.destroy_all
    User.create!(email: 'dan@example.com', role: 'dispatcher', password: 'password')
end

create_reports
create_accounts
