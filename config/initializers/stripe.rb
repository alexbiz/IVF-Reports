if Rails.env.production?
  Stripe.api_key = "sk_0Ab8r8aPHaaiclr6dDOYhh9hN54sl"
  STRIPE_PUBLIC_KEY = "pk_0Ab8kkgQYl1Ejc3mJBNN6juj9jhsA"  
else
  Stripe.api_key = "sk_0Ab8Oi8xvyATNRZIZ9ysDHDmOa6n9"
  STRIPE_PUBLIC_KEY = "pk_0Ab8TTNrXtxUXJ0DSxJqfpqmkCT15"
end