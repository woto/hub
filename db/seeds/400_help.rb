help_realm = Realm.create!(title: 'Помощь', locale: 'ru', kind: 'help')

['Начало работы', 'Общая информация', 'Площадки', 'Программы', 'Финансы', 'Инструменты',
 'Статистика', 'Настройки', 'Aliexpress', 'Техподдержка', 'GDPR'].each do |pc|
  PostCategory.create!(title: pc, realm: help_realm)
end
