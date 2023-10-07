defmodule HelloWeb.CalculationLiveTest do
  use HelloWeb.ConnCase

  import Phoenix.LiveViewTest
  import Hello.CalculatorFixtures

  @create_attrs %{value: 120.5}
  @update_attrs %{value: 456.7}
  @invalid_attrs %{value: nil}

  defp create_calculation(_) do
    calculation = calculation_fixture()
    %{calculation: calculation}
  end

  describe "Index" do
    setup [:create_calculation]

    test "lists all calculations", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/calculations")

      assert html =~ "Listing Calculations"
    end

    test "saves new calculation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/calculations")

      assert index_live |> element("a", "New Calculation") |> render_click() =~
               "New Calculation"

      assert_patch(index_live, ~p"/calculations/new")

      assert index_live
             |> form("#calculation-form", calculation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#calculation-form", calculation: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/calculations")

      html = render(index_live)
      assert html =~ "Calculation created successfully"
    end

    test "updates calculation in listing", %{conn: conn, calculation: calculation} do
      {:ok, index_live, _html} = live(conn, ~p"/calculations")

      assert index_live |> element("#calculations-#{calculation.id} a", "Edit") |> render_click() =~
               "Edit Calculation"

      assert_patch(index_live, ~p"/calculations/#{calculation}/edit")

      assert index_live
             |> form("#calculation-form", calculation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#calculation-form", calculation: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/calculations")

      html = render(index_live)
      assert html =~ "Calculation updated successfully"
    end

    test "deletes calculation in listing", %{conn: conn, calculation: calculation} do
      {:ok, index_live, _html} = live(conn, ~p"/calculations")

      assert index_live |> element("#calculations-#{calculation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#calculations-#{calculation.id}")
    end
  end

  describe "Show" do
    setup [:create_calculation]

    test "displays calculation", %{conn: conn, calculation: calculation} do
      {:ok, _show_live, html} = live(conn, ~p"/calculations/#{calculation}")

      assert html =~ "Show Calculation"
    end

    test "updates calculation within modal", %{conn: conn, calculation: calculation} do
      {:ok, show_live, _html} = live(conn, ~p"/calculations/#{calculation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Calculation"

      assert_patch(show_live, ~p"/calculations/#{calculation}/show/edit")

      assert show_live
             |> form("#calculation-form", calculation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#calculation-form", calculation: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/calculations/#{calculation}")

      html = render(show_live)
      assert html =~ "Calculation updated successfully"
    end
  end
end
