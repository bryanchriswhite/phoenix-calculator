defmodule HelloWeb.CalculationLive.Calculator do
  use HelloWeb, :live_component

#  alias Hello.Calculator
  import HelloWeb.CalculatorComponents

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :display, 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-4 border-4 rounded-lg">
      <div class="my-4 p-4 border-4 rounded-lg">
        <div class="w-full text-right"><%= @display %></div>
      </div>
      <div class="grid grid-cols-4 gap-4">
        <.calc_button target={@myself} value="7" />
        <.calc_button target={@myself} value="8" />
        <.calc_button target={@myself} value="9" />
        <.calc_button target={@myself} value="-" />

        <.calc_button target={@myself} value="4" />
        <.calc_button target={@myself} value="5" />
        <.calc_button target={@myself} value="6" />
        <.calc_button target={@myself} value="+" />

        <.calc_button target={@myself} value="1" />
        <.calc_button target={@myself} value="2" />
        <.calc_button target={@myself} value="3" />
        <.calc_button target={@myself} value="*" />

        <.calc_button target={@myself} value="_" />
        <.calc_button target={@myself} value="0" />
        <.calc_button target={@myself} value="." />
        <.calc_button target={@myself} value="/" />
      </div>
      <div class="pt-4">
        <.calc_button target={@myself} value="=" class="w-full"/>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event(event, _params, socket) do
    {:noreply, assign(socket, :display, event)}
  end

  @impl true
  def update(_assigns, socket) do
    IO.puts "UPDATE CALLED!!"
    IO.puts "UPDATE CALLED!!"
    IO.puts "UPDATE CALLED!!"
    IO.puts "UPDATE CALLED!!"
    {:ok, socket}
  end
end