defmodule Scrumex.TaskEvent do
  use Scrumex.Web, :model

  alias Scrumex.{User, Task, EventType, Repo}

  schema "task_events" do
    field :type, EventType
    field :message, :string

    belongs_to :task, Project
    belongs_to :author, User

    timestamps()
  end

  @required_fields [:message, :task_id]
  @optional_fields [:type, :author_id]

  def changeset(struct, params \\ %{}) do
    changeset_fields(struct, params, @required_fields, @optional_fields)
  end

  defp changeset_fields(struct, params, required_fields, optional_fields) do
    struct
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
