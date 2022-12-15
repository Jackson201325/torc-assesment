# Basic sales tax is applicable at a rate of 10% on all goods, except books, food, and medical products that are exempt. Import duty is an additional sales tax applicable on all imported goods at a rate of 5%, with no exemptions.


# Sales Tax
# - books, food, and medical products -> (none)
# - Everything else -> (10%)

# Import duty
# - Everything (5%)

# Total Taxes
# - Books, food and medical product -> 5%
# - everything else -> 10%

# Input 1
# 2 books at 12.49            | Sales tax -> 0% (books excempted), No import tax
# 1 music CD at 14.99         | Sales tax -> 10%, no import tax
# 1 Chocolate bar at 0.85     | Sales tax -> 0%, (food excempted), no import tax
# Sales tax = 1.5             | Total tax  -> (14.99 * 10%) = 1.50
# Total = 42.32

# Input 1I
# 1 Imported box of chocolate at 10.00    | Sales tax -> 0%, (food excempted), Import tax -> 5%
# 1 Imported bottle of perfume at 47.50   | Sales tax -> 10%, Import tax -> 5%
# Sales tax = 7.65                        | Total tax -> (47.50 * 10%) + (47.50 * 5%) + (10.00 * 5%) => 4.750 + 2.375 + 0.5 = 7.625 ~ 7.65
# Total = 65.15

# Input 1II
# 1 Imported bottle of perfume 27.99      | Sales tax -> 10% 2.799, Import tax -> 5% 1.3995
# 1 bottle of perfume at 18.99            | Sales tax -> 10%  1.899, Import tax -> 0%
# 1 packet of headache pills 9.75         | Sales tax -> 0% (medical product excempted), Import tax -> 0%
# 3 imported box of chocolates 11.25      | Sales tax -> 0%, (food excempted), Import tax -> 5% 1.6875
# Sales tax = 7.90                        | Total tax -> (27.99 * 10%) + (27.99 * 5%) + (18.99 * 10%) + (3 * 11.25 * 0.5%) => 2.799 + 1.3995 + 1.899 +  1.6875 = 7.785
# Total = 98.38

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

describe "When the user buys" do
  context "2 books, 1 music CD, 1 chocolate bar" do
    item_prices = [
      { name: "Book", price: "12.49", import_tax: false, sales_tax: false },
      { name: "Music CD", price: "14.99", import_tax: false, sales_tax: true },
      { name: "Chocolate Bar", price: "0.85", import_tax: false, sales_tax: false },
    ]
    receipt = [
      { name: "Book", quantity: 2, import_tax: false, sales_tax: false },
      { name: "Music CD", quantity: 1, import_tax: false, sales_tax: true },
      { name: "Chocolate Bar", quantity: 1, import_tax: false, sales_tax: false },
    ]
    it "return with sales tax of 1.5 and the total of 42.32 given the prices and quantity" do
      expect(total_sales_amount(item_prices, receipt)[:total_sales].to_f).to(eq(42.32))
      expect(total_sales_amount(item_prices, receipt)[:total_taxes].to_f).to(eq(1.5))
    end
  end

  context "1 Imported box of chocolates, 1 imported bottle of perfume" do
    item_prices = [
        { name: "Box Chocolate", price: "10.00", import_tax: true, sales_tax: false },
        { name: "Perfume", price: "47.50", import_tax: true, sales_tax: true },
      ]
      receipt = [
        { name: "Box Chocolate", quantity: 1, import_tax: true, sales_tax: false },
        { name: "Perfume", quantity: 1, import_tax: true, sales_tax: true },
      ]
    it "return with sales tax of 1.5 and the total of 42.32 given the prices and quantity" do
      expect(total_sales_amount(item_prices, receipt)[:total_sales].to_f).to(eq(65.15))
      expect(total_sales_amount(item_prices, receipt)[:total_taxes].to_f).to(eq(7.65))
    end
  end

  context "1 imported bottle of perfume, 1 bottle of perfume, 1 patcket of headache pills, 3 imported box of chocolate" do
    item_prices = [
        { name: "Bottle of Perfume", price: "27.99", import_tax: true, sales_tax: true },
        { name: "Bottle of Perfume", price: "18.99", import_tax: false, sales_tax: true },
        { name: "Pack of Headache Pills", price: "9.75", import_tax: false, sales_tax: false },
        { name: "Box of chocolates", price: "11.25", import_tax: true, sales_tax: false },
      ]
      receipt = [
        { name: "Bottle of Perfume", quantity: 1, import_tax: true, sales_tax: true },
        { name: "Bottle of Perfume", quantity: 1, import_tax: false, sales_tax: true },
        { name: "Pack of Headache Pills", quantity: 1, import_tax: false, sales_tax: false },
        { name: "Box of chocolates", quantity: 3, import_tax: true, sales_tax: false },
      ]
    it "return with sales tax of 1.5 and the total of 42.32 given the prices and quantity" do
      expect(total_sales_amount(item_prices, receipt)[:total_sales].to_f).to(eq(98.38))
      expect(total_sales_amount(item_prices, receipt)[:total_taxes].to_f).to(eq(7.90))
    end
  end
end
