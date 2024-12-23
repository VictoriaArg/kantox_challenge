defmodule PromoMarketWeb.OrderLive.FormComponent do
  use PromoMarketWeb, :live_component

  alias PromoMarket.Market

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%!-- {@title} --%> Order Form
        <:subtitle>Use this form to manage order records in your database.</:subtitle>
      </.header>

      <%!-- <.simple_form
        for={@form}
        id="order-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:total]} type="number" label="Total" />
        <.input field={@form[:state]} type="text" label="State" />
        <.input field={@form[:recipient]} type="text" label="Recipient" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:delivery_date]} type="datetime-local" label="Delivery date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Order</.button>
        </:actions>
      </.simple_form> --%>
    </div>
    """
  end

  # @impl true
  # def update(%{order: order} = assigns, socket) do
  #   {:ok,
  #    socket
  #    |> assign(assigns)
  #    |> assign_new(:form, fn ->
  #      to_form(Market.change_order(order))
  #    end)}
  # end

  @impl true
  def update(_, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"order" => order_params}, socket) do
    changeset = Market.change_order(socket.assigns.order, order_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"order" => order_params}, socket) do
    save_order(socket, socket.assigns.action, order_params)
  end

  defp save_order(socket, :new, order_params) do
    case Market.create_order(order_params) do
      {:ok, order} ->
        notify_parent({:saved, order})

        {:noreply,
         socket
         |> put_flash(:info, "Order created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
