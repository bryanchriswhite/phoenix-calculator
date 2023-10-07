defmodule Hello.CalculatorTest do
  use Hello.DataCase

  alias Hello.Calculator

  describe "calculations" do
    alias Hello.Calculator.Calculation

    import Hello.CalculatorFixtures

    @invalid_attrs %{value: nil}

    test "list_calculations/0 returns all calculations" do
      calculation = calculation_fixture()
      assert Calculator.list_calculations() == [calculation]
    end

    test "get_calculation!/1 returns the calculation with given id" do
      calculation = calculation_fixture()
      assert Calculator.get_calculation!(calculation.id) == calculation
    end

    test "create_calculation/1 with valid data creates a calculation" do
      valid_attrs = %{value: 120.5}

      assert {:ok, %Calculation{} = calculation} = Calculator.create_calculation(valid_attrs)
      assert calculation.value == 120.5
    end

    test "create_calculation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calculator.create_calculation(@invalid_attrs)
    end

    test "update_calculation/2 with valid data updates the calculation" do
      calculation = calculation_fixture()
      update_attrs = %{value: 456.7}

      assert {:ok, %Calculation{} = calculation} = Calculator.update_calculation(calculation, update_attrs)
      assert calculation.value == 456.7
    end

    test "update_calculation/2 with invalid data returns error changeset" do
      calculation = calculation_fixture()
      assert {:error, %Ecto.Changeset{}} = Calculator.update_calculation(calculation, @invalid_attrs)
      assert calculation == Calculator.get_calculation!(calculation.id)
    end

    test "delete_calculation/1 deletes the calculation" do
      calculation = calculation_fixture()
      assert {:ok, %Calculation{}} = Calculator.delete_calculation(calculation)
      assert_raise Ecto.NoResultsError, fn -> Calculator.get_calculation!(calculation.id) end
    end

    test "change_calculation/1 returns a calculation changeset" do
      calculation = calculation_fixture()
      assert %Ecto.Changeset{} = Calculator.change_calculation(calculation)
    end
  end
end
