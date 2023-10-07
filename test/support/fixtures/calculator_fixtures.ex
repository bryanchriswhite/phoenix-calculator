defmodule Hello.CalculatorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hello.Calculator` context.
  """

  @doc """
  Generate a calculation.
  """
  def calculation_fixture(attrs \\ %{}) do
    {:ok, calculation} =
      attrs
      |> Enum.into(%{
        value: 120.5
      })
      |> Hello.Calculator.create_calculation()

    calculation
  end
end
