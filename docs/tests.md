# Tests

```shell
bundle exec rspec
```

### Usefull notes

```ruby
Faker::Name.name

Faker::Lorem.paragraph

Faker::PhoneNumber.cell_phone_with_country_code

fill_in 'id, name, placeholder', with: value

within find('selector') do
  ...
end

find('selector').click

find('selector', text: 'WhatsApp').click

expect(page).to have_button(text: 'WhatsApp')

within find_by_id('element id') do
  ...
end

expect(page).to have_field('name', type: :hidden, with: 'WhatsApp'

expect(page).to have_select('name', visible: :hidden, selected: ['item'])

trait(:with_avatar) do
  after(:create) do |user|
    user.avatar.attach(io: File.open(Rails.root.join('spec/fixtures/files/avatar.png')), filename: 'avatar.png')
  end
end

@avatar_path = if helpers.current_user.avatar.attached?
                  helpers.url_for(@avatar.variant(resize_to_limit: [200, 200]))
                else
                  asset_path('avatar-placeholder.png')
                end

hsh[:avatar] = if user.avatar.present?
                 Rails.application.routes.url_helpers.polymorphic_path(
                   user.avatar.variant(resize_to_limit: [200, 200]),
                   only_path: true
                 )
               else
                 ApplicationController.helpers.asset_path('avatar-placeholder.png')
               end


expect(page).to have_no_css('selector')

expect(response).to have_http_status(:ok)
expect(response.parsed_body).to contain_exactly({ 'id' => user.id, 'email' => user.email })
expect(response).to have_http_status(403)

current_user.avatar.attach(params[:file])

page.attach_file(file_fixture(avatar_name)) do
  find('#avatar-clickable').click
end

expect(user.reload.avatar.filename.to_s).to eq(avatar_name)

sign_in user

expect(response).to have_http_status(:no_content)

expect(response.body).to eq('')

expect(user.avatar).to be_attached
```
