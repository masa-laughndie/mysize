User.create!(name: "Masa",
             email: "mysize@example.com",
             mysize_id: "masa",
             password: "foobar",
             password_confirmation: "foobar",
             shoe_size: 10,
             image: open("#{Rails.root}/db/data/icon1.jpg"),
             profile_content: "Jordan1(26.5cm)/Kithコラボが好きです！",
             admin: true)

19.times do |n|
  name = Faker::Name.name
  email = "mysize-#{n+1}@example.com"
  mysize_id = "mysize_#{n+1}"
  password = "password"
  shoe_size = rand(1..17)
  image = open("#{Rails.root}/db/data/icon#{rand(2..10)}.jpg")
  profile_content = Faker::Lorem.sentence(5)
  User.create!(name: name,
               email: email,
               mysize_id: mysize_id,
               password: password,
               password_confirmation: password,
               shoe_size: shoe_size,
               image: image,
               profile_content: profile_content)
end

users = User.order(:created_at).take(6)
5.times do
  users.each do |user|
    user.kicksposts.create!(content: Faker::Lorem.sentence(5),
                            picture: open("#{Rails.root}/db/data/kicks#{rand(1..15)}.jpg"),
                            size: rand(1..17))
  end
end