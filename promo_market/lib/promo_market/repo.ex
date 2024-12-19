defmodule PromoMarket.Repo do
  use Ecto.Repo,
    otp_app: :promo_market,
    adapter: Ecto.Adapters.Postgres
end
