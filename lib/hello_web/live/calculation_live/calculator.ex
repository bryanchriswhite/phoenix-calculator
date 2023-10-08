defmodule HelloWeb.CalculationLive.Calculator do
  use HelloWeb, :live_component

#  alias Hello.Calculator
  import HelloWeb.CalculatorComponents

  @impl true
  def mount(socket) do
    {:ok, assign(socket, %{
      display: "0",
      input_int: 0,
      input_frac: -1,
      acc: nil,
      operator: nil,
      stack: [],
    })}
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

        <.calc_button target={@myself} value="C" />
        <.calc_button target={@myself} value="0" />
        <.calc_button target={@myself} value="." />
        <.calc_button target={@myself} value="/" />
      </div>
      <div class="grid grid-cols-4 gap-4 pt-4">
        <.calc_button target={@myself} value="AC" class="col-span-1 w-full"/>
        <.calc_button target={@myself} value="=" class="col-span-3 w-full"/>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event(event, _params, socket) when event in ~w(0 1 2 3 4 5 6 7 8 9) do
    {key_int, _} = Integer.parse(event)

    %{
      input_int: input_int,
      input_frac: input_frac,
    } = socket.assigns

#    IO.puts "input_int: #{input_int}, input_frac: #{input_frac}"
    input_int =
      if input_frac == -1 do
        input_int * 10 + key_int
      else
        input_int
      end

    input_frac =
      if input_frac != -1 do
        input_frac * 10 + key_int
      else
        input_frac
      end

    display =
      case input_frac do
        -1 -> "#{input_int}"
        _ -> "#{input_int}.#{input_frac}"
      end

    assigns =%{
      display: display,
      input_int: input_int,
      input_frac: input_frac,
    }

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event(".", _params, socket) do
    %{
      display: display,
      input_int: input_int,
      input_frac: input_frac,
      operator: operator,
    } = socket.assigns

    display =
      case input_frac do
        -1 when operator != nil and input_int == 0 -> "0."
        -1 when operator != nil -> "#{input_int}."
        -1 -> display <> "."
      end

    assigns = %{
      display: display,
      input_frac: 0,
    }

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("+", _params, socket) do
    assigns = socket.assigns |> operator("+", &Kernel.+/2)

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("-", _params, socket) do
    assigns = socket.assigns |> operator("-", &Kernel.-/2)

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("*", _params, socket) do
    assigns = socket.assigns |> operator("*", &Kernel.*/2)

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("/", _params, socket) do
    assigns = socket.assigns |> operator("/", &Kernel.//2)

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("=", _params, socket) do
    %{
      input_int: input_int,
      input_frac: input_frac,
      display: display,
      acc: acc,
      operator: operator,
      stack: stack,
    } = socket.assigns

    {input, _} = Float.parse("#{input_int}.#{input_frac}")

    # update the stack
    stack =
      case {input_int, input_frac} do
        # input is reset, don't update the stack
        {0, -1} -> stack
        # otherwise, push the input onto the stack
        _ -> [input | stack]
      end

    [operand_2 | [operand_1 | _]] =
      case Enum.count stack do
        0 -> [0, 0]
        2 when acc == nil -> stack
        2 -> [stack |> Enum.at(0), acc]
      end

#    IO.puts "operand_1: #{operand_1}, operand_2: #{operand_2}"

    acc =
      case operator do
        nil -> acc
        # TODO: handle n-ary operators
        _ -> operator.(operand_1, operand_2)
      end

    {acc_int, acc_frac} = Integer.parse("#{acc}")
    IO.puts "acc_int: #{acc_int}, acc_frac: #{acc_frac}"
    acc_is_int =
      case acc_frac do
        ".0" -> true
        _ -> false
      end

    display =
      case acc do
        nil -> display
        _ when acc_is_int -> acc_int
        _ -> acc
      end

    assigns = %{
      display: display,
      # reset input, it's on the stack
      input_int: 0,
      input_frac: -1,
      acc: acc,
      stack: stack,
    }
    IO.puts "assigns"
    IO.inspect assigns

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("AC", _params, socket) do
    assigns = %{
      display: "0",
      input_int: 0,
      input_frac: -1,
      acc: nil,
      stack: [],
    }

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("C", _params, socket) do
    %{
      input_int: input_int,
      display: display,
    } = socket.assigns

    display = case input_int do
      0 -> display
      _ -> "0"
    end

    assigns = %{
      display: display,
      input_int: 0,
      input_frac: -1,
    }

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event(event, _params, socket) do
    IO.puts "UNSUPPORTED EVENT: #{event}"
    {:noreply, socket}
  end

  @impl true
  def update(_assigns, socket) do
    {:ok, socket}
  end

  defp operator(assigns, symbol, operator_fn) do
    %{
      display: display,
      input_int: input_int,
      input_frac: input_frac,
    } = assigns

    {input, _} = Float.parse("#{input_int}.#{input_frac}")

    %{
      display: "#{symbol} #{display}",
      input_int: 0,
      input_frac: -1,
      operator: operator_fn,
      stack: [input],
    }
  end
end
