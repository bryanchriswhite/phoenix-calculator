defmodule HelloWeb.CalculatorComponents do
  use Phoenix.Component

  import HelloWeb.CoreComponents

  attr :value, :string, required: true
  attr :target, :string, required: true
  attr :class, :string, default: ""
  attr :rest, :global

  def calc_button(assigns) do
    ~H"""
    <.button
      phx-click={@value}
      phx-target={@target}
      class={default_class() <> @class}
      {@rest}
    >
      <%= @value %>
    </.button>
    """
  end

  defp default_class() do
    "text-black active:text-black/80 bg-gray-200 hover:bg-gray-300 py-4 px-4 "
  end
end