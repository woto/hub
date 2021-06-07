json.array! @users do |user|
  json.id user.id.to_i
  json.email user.email
end
