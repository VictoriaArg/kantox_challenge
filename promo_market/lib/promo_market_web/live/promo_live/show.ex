defmodule PromoMarketWeb.PromoLive.Show do
  use PromoMarketWeb, :live_view

  alias PromoMarket.Sales

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:promo, Sales.get_promo!(id))}
  end

  defp page_title(:show), do: "Show Promo"
  defp page_title(:edit), do: "Edit Promo"
end
