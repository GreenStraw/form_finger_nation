Rails.application.config.stripe = {
  :publishable_key => ENV['STRIPE_PUBLIC_KEY'],
  :secret_key      => ENV['STRIPE_API_KEY']
}

Stripe.api_key = Rails.application.config.stripe[:secret_key]