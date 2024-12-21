defmodule PromoMarket.Repo.Migrations.AddAvailableAfterFieldForPromos do
  use Ecto.Migration

  def change do
    alter table(:promos) do
      add :min_units, :integer, null: false
    end
  end
end
