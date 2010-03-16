Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :facebook_id do |n|
  n
end

Factory.define :user do |user|
  user.email                 { Factory.next :email }
  user.first_name            { "Factory" }
  user.last_name             { "User" }
  user.password              { "password" }
  user.password_confirmation { "password" }
end

Factory.define :admin_user, :parent => :user do |admin|
  admin.role                 'admin'
end

Factory.define :facebook_user, :parent => :user do |user|
  user.facebook_uid           { Factory.next :facebook_id }
end
