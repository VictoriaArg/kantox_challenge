defmodule PromoMarketWeb.OrderLive.FormComponent do
  use PromoMarketWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Order Form
        <:subtitle>
          <p>Thank you for reviewing my challenge submit.
            Hope that we can develop the greatest features in 2025.
            Merry Christmas and happy new year!</p>
          <br />
          <p class="mt-2">Best regards,</p>
        </:subtitle>
      </.header>

      <p class="text-purple-900 font-bold, leading-6 ">Victoria Argañaras</p>
    </div>
    """
  end
end
