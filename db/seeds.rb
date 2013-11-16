Report.destroy_all

Report.create({
    name: "Ella",
    phone: "209-559-2459",
    lat: 37.782983333333334,
    long: 122.4065,
    nature: "they tuk our jobs"
    })

15.times do
  Report.create({
    name: Faker::Name.name,
    phone: Faker::PhoneNumber.cell_phone,
    lat: rand(200),
    long: rand(200),
    nature: Faker::Company.bs
    })
end
