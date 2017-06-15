defmodule Scrumex.Task do
  use Scrumex.Web, :model

  alias Scrumex.{User, Task, ProjectStatus, ProjectPriority, Repo}

  schema "tasks" do
    field :name, :string
    field :description, :string

    belongs_to :project, Project
    belongs_to :status, ProjectStatus
    belongs_to :priority, ProjectPriority
    belongs_to :author, User

    timestamps()
  end

  @required_fields [:name, :description, :project_id, :status_id, :priority_id, :author_id]
  @optional_fields []

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    changeset_fields(struct, params, @required_fields, @optional_fields)
  end

  def priorities() do
    [
      %{id: 1, name: "Low"},
      %{id: 2, name: "Normal"},
      %{id: 3, name: "High"},
    ]
  end

  defp changeset_fields(struct, params, required_fields, optional_fields) do
    struct
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
