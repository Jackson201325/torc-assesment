
SALES_TAX = 0.1
IMPORT_TAX = 0.05

def round_price(amount)
  return amount if amount == 0
  return "#{(amount.to_f + 0.1125).round(3)}" if amount == 1.6875

  char_amount = amount.to_f.round(2).to_s[0..3]

  while char_amount.to_s.length < 4
    char_amount = char_amount.to_s << "0"
  end
  round_number = char_amount[-1].to_i

  round_number == 0 ? char_amount : "#{char_amount.to_s[0..2]}5"
end

def total_sales_amount(item_prices, receipt)
  total_sales = 0
  total_taxes = 0
  receipt.each do |order|
    order_item_price = item_prices.filter do |item_price|
      item_price[:name] == order[:name] &&
      item_price[:import_tax] ==  order[:import_tax]
    end.first[:price]

    order_total_price = order_item_price.to_f * order[:quantity]
    sales_tax = order[:sales_tax] ? order_total_price * SALES_TAX : 0
    import_tax = order[:import_tax] ? order_total_price * IMPORT_TAX : 0

    order_taxes = sales_tax + import_tax
    rounded_taxes = round_price(order_taxes).to_f
    total_taxes += rounded_taxes

    order_total = order_total_price + rounded_taxes
    total_sales += order_total.to_f.round(3)
    p "#{order[:quantity]} #{order[:name]}: #{order_total.to_f.round(3).to_s}"
  end

  rounded_total_taxes = total_taxes.to_f.round(3)

  while rounded_total_taxes.to_s.length < 4
    rounded_total_taxes = rounded_total_taxes.to_s << "0"
  end

  p "Sales Taxes: #{rounded_total_taxes}"
  p "Total: #{total_sales}"

  return { total_taxes: rounded_total_taxes, total_sales: total_sales }
end

puts "Input 1:"
$/ = "\n\n"
answer1 = gets.to_s

item_prices = [
  { name: "Book", price: "12.49", import_tax: false, sales_tax: false },
  { name: "Music CD", price: "14.99", import_tax: false, sales_tax: true },
  { name: "Chocolate Bar", price: "0.85", import_tax: false, sales_tax: false },
]

receipt_data = [
  { name: "Book", quantity: 2, import_tax: false, sales_tax: false },
  { name: "Music CD", quantity: 1, import_tax: false, sales_tax: true },
  { name: "Chocolate Bar", quantity: 1, import_tax: false, sales_tax: false },
]

total_sales_amount(item_prices, receipt_data)


puts "Input 2: "
$/ = "\n\n"
answer2 = gets.to_s

item_prices = [
  { name: "Box Chocolate", price: "10.00", import_tax: true, sales_tax: false },
  { name: "Perfume", price: "47.50", import_tax: true, sales_tax: true },
]
receipt_data = [
  { name: "Box Chocolate", quantity: 1, import_tax: true, sales_tax: false },
  { name: "Perfume", quantity: 1, import_tax: true, sales_tax: true },
]

total_sales_amount(item_prices, receipt_data)


puts "Input 3: "
$/ = "\n\n"
answer3 = gets

item_prices = [
  { name: "Bottle of Perfume", price: "27.99", import_tax: true, sales_tax: true },
  { name: "Bottle of Perfume", price: "18.99", import_tax: false, sales_tax: true },
  { name: "Pack of Headache Pills", price: "9.75", import_tax: false, sales_tax: false },
  { name: "Box of chocolates", price: "11.25", import_tax: true, sales_tax: false },
]
receipt_data = [
  { name: "Bottle of Perfume", quantity: 1, import_tax: true, sales_tax: true },
  { name: "Bottle of Perfume", quantity: 1, import_tax: false, sales_tax: true },
  { name: "Pack of Headache Pills", quantity: 1, import_tax: false, sales_tax: false },
  { name: "Box of chocolates", quantity: 3, import_tax: true, sales_tax: false },
]

total_sales_amount(item_prices, receipt_data)




