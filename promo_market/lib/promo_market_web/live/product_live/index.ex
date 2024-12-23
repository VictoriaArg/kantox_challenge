defmodule PromoMarketWeb.ProductLive.Index do
  use PromoMarketWeb, :live_view

  alias PromoMarket.Catalog
  alias PromoMarket.Market
  alias PromoMarket.Market.BasketItem
  alias PromoMarket.Checkout

  @impl true
  def mount(_params, _session, socket) do
    updated_socket =
      socket
      |> assign(basket_items: %{})
      |> stream(:products, Catalog.list_products())

    {:ok, updated_socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
  end

  @impl true
  def handle_event(
        "new_basket_item",
        %{"id" => id},
        %{assigns: %{basket_items: basket_items}} = socket
      ) do
    product = Catalog.get_product!(id)

    params = %{
      name: product.name,
      product_id: product.id,
      amount: 1,
      price: product.price,
      applied_promo: nil
    }

    {:ok, new_basket_item} = Market.new_basket_item(params)
    processed_basket_item = Checkout.process_basket_item(new_basket_item)

    socket =
      socket
      |> assign(basket_items: Map.put(basket_items, product.code, processed_basket_item))
      |> stream(:products, Catalog.list_products())

    {:noreply, socket}
  end

  def handle_event(
        "update_item_amount",
        %{"code" => code, "action" => action},
        %{assigns: %{basket_items: basket_items}} = socket
      ) do
    old_basket_item = basket_items[code]
    updated_item = update_item(old_basket_item, action)

    updated_basket_items = update_basket_items(basket_items, code, updated_item)

    socket =
      socket
      |> assign(basket_items: updated_basket_items)
      |> stream(:products, Catalog.list_products())

    {:noreply, socket}
  end

  def already_in_basket?(basket_items, product_code) do
    Map.has_key?(basket_items, product_code)
  end

  def update_item(%BasketItem{amount: 1}, "subtract"), do: nil

  def update_item(%BasketItem{amount: amount} = item, action) do
    new_amount = update_amount(amount, action)
    updated_basket_item = Market.update_basket_item(item, %{amount: new_amount})

    Checkout.process_basket_item(updated_basket_item)
  end

  def update_basket_items(basket_items, code, nil) do
    Map.drop(basket_items, [code])
  end

  def update_basket_items(basket_items, code, updated_item) do
    Map.put(basket_items, code, updated_item)
  end

  defp update_amount(amount, "add"), do: amount + 1
  defp update_amount(amount, "subtract"), do: amount - 1
end
