# frozen_string_literal: true

User.create!(
  email: 'oganer@gmail.com',
  password: 'qweQWE123!@#',
  role: 'admin'
)

Doorkeeper::Application.create!(
  name: 'Swagger',
  uid: 'fforGBoTVuZaMNMbp9jY7VEjk03_MX7On38Dtzt7Ei4',
  secret: '_Dn1afy_S9487VxKMp56LnaKwcob9EjgRoKl1mWBzG4',
  redirect_uri: 'https://nv6.ru/swagger/oauth2-redirect.html',
  scopes: 'read',
  confidential: true
)
