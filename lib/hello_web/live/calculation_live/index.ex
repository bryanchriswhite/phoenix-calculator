defmodule HelloWeb.CalculationLive.Index do
  use HelloWeb, :live_view

  alias Hello.Calculator
  alias Hello.Calculator.Calculation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :calculations, Calculator.list_calculations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Calculation")
    |> assign(:calculation, Calculator.get_calculation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Calculation")
    |> assign(:calculation, %Calculation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Calculations")
    |> assign(:calculation, nil)
  end

  @impl true
  def handle_info({HelloWeb.CalculationLive.FormComponent, {:saved, calculation}}, socket) do
    {:noreply, stream_insert(socket, :calculations, calculation)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    calculation = Calculator.get_calculation!(id)
    {:ok, _} = Calculator.delete_calculation(calculation)

    {:noreply, stream_delete(socket, :calculations, calculation)}
  end
end
