defmodule PromoMarket.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :code, :string
      add :price, :integer
      add :stock, :integer
      add :description, :string
      add :image_upload, :string

      timestamps(type: :utc_datetime)
    end
  end
end
