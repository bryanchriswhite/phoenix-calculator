defmodule  HelloWeb.CalculationLive.Calculate  do
  use HelloWeb, :live_view

#  alias Hello.Calculator
#  alias Hello.Calculator.Calculation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event(_name, _params, socket) do
    {:noreply, socket}
  end
end