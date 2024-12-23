defmodule PromoMarket.Market do
  @moduledoc """
  The Market context.
  """

  import Ecto.Query, warn: false
  alias PromoMarket.Repo
  alias Ecto.Changeset
  alias PromoMarket.Market.{Basket, BasketItem, Order}

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates an order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` to create an order from a basket.

  ## Examples

      iex> order_changeset_from_basket(%Basket{...}, attrs)
      %Ecto.Changeset{data: %Order{}}

  """
  def order_changeset_from_basket(%Basket{} = basket, attrs) do
    order_params =
      basket
      |> Map.from_struct()
      |> Map.merge(attrs)

    change_order(%Order{}, order_params)
  end

  @doc """
  Returns a new basket struct.

  ## Examples

      iex> new_basket(attrs)
      {:ok, %Basket{}}

      iex> new_basket(%{total: "random_string"})
      {:error, changeset}

  """
  def new_basket(attrs) do
    changeset = validate_basket(%Basket{}, attrs)

    case changeset.valid? do
      true -> {:ok, Changeset.apply_changes(changeset)}
      _ -> {:error, changeset.errors}
    end
  end

  @doc """
  Returns a new basket struct.

  ## Examples

      iex> update_basket(basket, attrs)
      {:ok, %Basket{}}

      iex> update_basket(basket, %{total: "random_string"})
      {:error, changeset}

  """
  def update_basket(%Basket{} = basket, attrs) do
    changeset = validate_basket(basket, attrs)

    case changeset.valid? do
      true -> {:ok, Changeset.apply_changes(changeset)}
      _ -> {:error, changeset.errors}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` to validate a basket.

  ## Examples

      iex> validate_basket(%Basket{})
      %Ecto.Changeset{data: %Basket{}}

  """
  def validate_basket(basket, attrs \\ %{}) do
    Basket.changeset(basket, attrs)
  end

  @doc """
  Returns a new basket item struct.

  ## Examples

      iex> new_basket_item(attrs)
      {:ok, %BasketItem{}}

      iex> new_basket_item(%{amount: -1})
      {:error, changeset}

  """
  def new_basket_item(attrs) do
    changeset = validate_basket_item(%BasketItem{}, attrs)

    case changeset.valid? do
      true -> {:ok, Changeset.apply_changes(changeset)}
      _ -> {:error, changeset.errors}
    end
  end

  @doc """
  Returns a new basket item struct.

  ## Examples

      iex> update_basket_item(basket_item, attrs)
      {:ok, %BasketItem{}}

      iex> update_basket_item(basket_item, %{amount: -1})
      {:error, changeset}

  """
  def update_basket_item(basket_item, attrs) do
    changeset = validate_basket_item(basket_item, attrs)

    case changeset.valid? do
      true -> Changeset.apply_changes(changeset)
      _ -> {:error, changeset.errors}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` to validate a basket item.

  ## Examples

      iex> validate_basket_item(%BasketItem{})
      %Ecto.Changeset{data: %BasketItem{}}

  """
  def validate_basket_item(%BasketItem{} = basket_item, attrs \\ %{}) do
    BasketItem.changeset(basket_item, attrs)
  end
end
