defmodule Hello.Repo.Migrations.CreateCalculations do
  use Ecto.Migration

  def change do
    create table(:calculations) do
      add :value, :float

      timestamps()
    end
  end
end
