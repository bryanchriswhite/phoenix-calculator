defmodule HelloWeb.CalculationLive.FormComponent do
  use HelloWeb, :live_component

  alias Hello.Calculator

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage calculation records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="calculation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:value]} type="number" label="Value" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Calculation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{calculation: calculation} = assigns, socket) do
    changeset = Calculator.change_calculation(calculation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"calculation" => calculation_params}, socket) do
    changeset =
      socket.assigns.calculation
      |> Calculator.change_calculation(calculation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"calculation" => calculation_params}, socket) do
    save_calculation(socket, socket.assigns.action, calculation_params)
  end

  defp save_calculation(socket, :edit, calculation_params) do
    case Calculator.update_calculation(socket.assigns.calculation, calculation_params) do
      {:ok, calculation} ->
        notify_parent({:saved, calculation})

        {:noreply,
         socket
         |> put_flash(:info, "Calculation updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_calculation(socket, :new, calculation_params) do
    case Calculator.create_calculation(calculation_params) do
      {:ok, calculation} ->
        notify_parent({:saved, calculation})

        {:noreply,
         socket
         |> put_flash(:info, "Calculation created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
