
processor = ask "Did you create a Stripe account? (y/n)"

if processor.downcase == "yes" || processor == "y"
  gem "pay", "~> 6.0"

  # To use Stripe, also include:
  gem "stripe", "~> 9.0"
  
  # To use Braintree + PayPal, also include:
  gem "braintree", "~> 4.7"
  
  # To use Paddle, also include:
  gem "paddle_pay", "~> 0.2"
  
  # To use Receipts gem for creating invoice and receipt PDFs, also include:
  gem "receipts", "~> 2.0"
elsif processor.downcase == "no" || processor == "n"
  puts "You need to create a Stripe account to use Pay. You can sign up at https://stripe.com"
else
  puts "Um, we don't know what #{processor} is 😅"
  abort
end

run "bundle install"

model = ask "What is the name of your 'billable' model? (Default: User)"
model = "User" if model.blank?

rails_command("pay:install:migrations")
generate(:pay, model)
run("rake db:migrate")

signing_secret = ask "What is your Stripe signing secret?"
publishable_key = ask "What is your Stripe publishable key?"
webhook_secret = ask "What is your Stripe webhook secret?"

# insert_into_file "config/initializers/pay.rb", after: "# config.stripe.publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']\n" do
#   <<~RUBY
#   config.stripe.signing_secret = "#{ENV['STRIPE_SIGNING_SECRET']}"
#   config.stripe.publishable_key = "#{ENV['STRIPE_PUBLISHABLE_KEY']}"
#   config.stripe.webhook_secret = "#{ENV['STRIPE_WEBHOOK_SECRET']}"
#   RUBY

puts "❗ Don't forget to add your #{processor} credentials to your application! https://github.com/pay-rails/pay#payment-providers"
puts "💰 Go forth and make money!"