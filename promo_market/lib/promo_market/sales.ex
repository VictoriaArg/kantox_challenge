defmodule PromoMarket.Sales do
  @moduledoc """
  The Sales context.

  Provides functions to manage promos, including creating, updating, deleting,
  and querying promos, as well as specific utilities to check eligibility.
  """

  import Ecto.Query, warn: false
  alias PromoMarket.Repo

  alias PromoMarket.Sales.Promo

  @doc """
  Returns the list of promos.

  ## Examples

      iex> list_promos()
      [%Promo{}, ...]

  """
  def list_promos do
    Repo.all(Promo)
  end

  @doc """
  Gets a single promo by its ID.

  Raises `Ecto.NoResultsError` if the Promo does not exist.

  ## Examples

      iex> get_promo!(123)
      %Promo{}

      iex> get_promo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_promo!(id), do: Repo.get!(Promo, id)

  @doc """
  Fetches the active promo for a given product ID.

  Returns `nil` if no active promo is found.

  ## Examples

      iex> get_active_promo_by_product_id("3995b9f2-e012-4b78-8eba-6f099b7dfd3a")
      %Promo{}

      iex> get_active_promo_by_product_id("false_uuid")
      nil
  """
  @spec get_active_promo_by_product_id(Ecto.UUID.t()) :: PromoMarket.Sales.Promo.t() | nil
  def get_active_promo_by_product_id(product_id) do
    Promo.active_promo_query(product_id)
    |> Repo.one()
  end

  @doc """
  Creates a new promo.

  Returns `{:ok, promo}` if the promo is successfully created, or
  `{:error, changeset}` if creation fails.

  ## Examples

      iex> create_promo(%{field: value})
      {:ok, %Promo{}}

      iex> create_promo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_promo(attrs \\ %{}) do
    %Promo{}
    |> Promo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing promo.

  Returns `{:ok, promo}` if the update is successful, or
  `{:error, changeset}` if the update fails.

  ## Examples

      iex> update_promo(promo, %{field: new_value})
      {:ok, %Promo{}}

      iex> update_promo(promo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_promo(%Promo{} = promo, attrs) do
    promo
    |> Promo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a promo.

  Returns `{:ok, promo}` if the promo is successfully deleted, or
  `{:error, changeset}` if the deletion fails.

  ## Examples

      iex> delete_promo(promo)
      {:ok, %Promo{}}

      iex> delete_promo(promo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_promo(%Promo{} = promo) do
    Repo.delete(promo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking promo changes.

  Use this function to prepare a promo for editing without saving it.

  ## Examples

      iex> change_promo(promo)
      %Ecto.Changeset{data: %Promo{}}

  """
  def change_promo(%Promo{} = promo, attrs \\ %{}) do
    Promo.changeset(promo, attrs)
  end

  @doc """
  Checks if a promo applies based on the given criteria.

  Returns `true` if the promo applies, or `false` otherwise.

  ## Examples

      iex> applies_for_promo?(%Promo{min_units: 3, product_id: 123}, %{product_id: 123, amount: 5})
      true

      iex> applies_for_promo?(%Promo{min_units: 3, product_id: 456}, %{product_id: 123, amount: 1})
      false

  """
  @spec applies_for_promo?(Promo.t(), map()) :: boolean()
  def applies_for_promo?(%Promo{} = promo, %{product_id: product_id, amount: amount})
      when promo.product_id == product_id and amount >= promo.min_units,
      do: true

  def applies_for_promo?(_, _), do: false
end
