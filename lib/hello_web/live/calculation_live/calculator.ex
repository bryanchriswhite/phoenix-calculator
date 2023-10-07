defmodule HelloWeb.CalculationLive.Calculator do
  use HelloWeb, :live_component

  alias HelloWeb.Calculator

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Hello from calculation_live/calculator.ex</h1>
    """
  end

  @impl true
  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_update(assigns, _socket) do
    {:ok, assigns}
  end
end