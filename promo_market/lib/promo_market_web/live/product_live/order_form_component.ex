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
            I know there is so much to improve, and many more cases to test, but this is what I was able to do in the given time.
            Hope to hear from you soon!</p>
          <br />
          <p class="mt-2">Best regards,</p>
        </:subtitle>
      </.header>

      <p class="text-purple-900 font-bold, leading-6 ">Victoria Argañaras</p>
    </div>
    """
  end
end
