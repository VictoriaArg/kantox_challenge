defmodule PromoMarketWeb.PromoLive.FormComponent do
  use PromoMarketWeb, :live_component

  alias PromoMarket.Sales

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage promo records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="promo-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <.input field={@form[:discount_strategy]} type="text" label="Discount strategy" />
        <.input field={@form[:expiration_date]} type="datetime-local" label="Expiration date" />
        <.input field={@form[:stock_limit]} type="number" label="Stock limit" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Promo</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{promo: promo} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Sales.change_promo(promo))
     end)}
  end

  @impl true
  def handle_event("validate", %{"promo" => promo_params}, socket) do
    changeset = Sales.change_promo(socket.assigns.promo, promo_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"promo" => promo_params}, socket) do
    save_promo(socket, socket.assigns.action, promo_params)
  end

  defp save_promo(socket, :edit, promo_params) do
    case Sales.update_promo(socket.assigns.promo, promo_params) do
      {:ok, promo} ->
        notify_parent({:saved, promo})

        {:noreply,
         socket
         |> put_flash(:info, "Promo updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_promo(socket, :new, promo_params) do
    case Sales.create_promo(promo_params) do
      {:ok, promo} ->
        notify_parent({:saved, promo})

        {:noreply,
         socket
         |> put_flash(:info, "Promo created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
