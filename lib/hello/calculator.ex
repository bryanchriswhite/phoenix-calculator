defmodule Hello.Calculator do
  @moduledoc """
  The Calculator context.
  """

  import Ecto.Query, warn: false
  alias Hello.Repo

  alias Hello.Calculator.Calculation

  @doc """
  Returns the list of calculations.

  ## Examples

      iex> list_calculations()
      [%Calculation{}, ...]

  """
  def list_calculations do
    Repo.all(Calculation)
  end

  @doc """
  Gets a single calculation.

  Raises `Ecto.NoResultsError` if the Calculation does not exist.

  ## Examples

      iex> get_calculation!(123)
      %Calculation{}

      iex> get_calculation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_calculation!(id), do: Repo.get!(Calculation, id)

  @doc """
  Creates a calculation.

  ## Examples

      iex> create_calculation(%{field: value})
      {:ok, %Calculation{}}

      iex> create_calculation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_calculation(attrs \\ %{}) do
    %Calculation{}
    |> Calculation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a calculation.

  ## Examples

      iex> update_calculation(calculation, %{field: new_value})
      {:ok, %Calculation{}}

      iex> update_calculation(calculation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_calculation(%Calculation{} = calculation, attrs) do
    calculation
    |> Calculation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a calculation.

  ## Examples

      iex> delete_calculation(calculation)
      {:ok, %Calculation{}}

      iex> delete_calculation(calculation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_calculation(%Calculation{} = calculation) do
    Repo.delete(calculation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking calculation changes.

  ## Examples

      iex> change_calculation(calculation)
      %Ecto.Changeset{data: %Calculation{}}

  """
  def change_calculation(%Calculation{} = calculation, attrs \\ %{}) do
    Calculation.changeset(calculation, attrs)
  end
end
