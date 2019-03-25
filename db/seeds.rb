User.create!(
  name: "taku hirosawa",
  email: "taku@gmail.com",
  password: "hogehoge",
  password_confirmation: "hogehoge",
  admin: true
)
99.times do |n|
  name=Faker::Name.name
  email="example-#{n}@railstutorial.org"
  password="password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password
  )
end