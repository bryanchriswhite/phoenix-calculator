defmodule Hello.Calculator.Calculation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calculations" do
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(calculation, attrs) do
    calculation
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
