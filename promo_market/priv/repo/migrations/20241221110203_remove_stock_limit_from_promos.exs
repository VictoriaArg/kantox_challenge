defmodule PromoMarket.Repo.Migrations.RemoveStockLimitFromPromos do
  use Ecto.Migration

  def change do
    alter table(:promos) do
      remove :stock_limit
    end
  end
end
