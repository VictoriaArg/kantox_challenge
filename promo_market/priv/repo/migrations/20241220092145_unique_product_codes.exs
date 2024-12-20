defmodule PromoMarket.Repo.Migrations.UniqueProductCodes do
  use Ecto.Migration

  def change do
    create unique_index(:products, [:code])
  end
end
