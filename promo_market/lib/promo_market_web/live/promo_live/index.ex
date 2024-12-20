defmodule PromoMarketWeb.PromoLive.Index do
  use PromoMarketWeb, :live_view

  alias PromoMarket.Sales
  alias PromoMarket.Sales.Promo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :promos, Sales.list_promos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Promo")
    |> assign(:promo, Sales.get_promo!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Promo")
    |> assign(:promo, %Promo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Promos")
    |> assign(:promo, nil)
  end

  @impl true
  def handle_info({PromoMarketWeb.PromoLive.FormComponent, {:saved, promo}}, socket) do
    {:noreply, stream_insert(socket, :promos, promo)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    promo = Sales.get_promo!(id)
    {:ok, _} = Sales.delete_promo(promo)

    {:noreply, stream_delete(socket, :promos, promo)}
  end
end
