(10.days.ago.to_date..10.days.after.to_date).each do |day|
  value = 0.00064683
  sign = rand >= 0.5 ? 1 : -1
  ExchangeRate.create!(date: day, currency: :usd, value: value + (sign * value / 100 * rand(1..1.10)))
end
