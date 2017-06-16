defmodule Scrumex.Task do
  use Scrumex.Web, :model

  alias Scrumex.{User, Task, TaskEvent, Project, ProjectStatus, ProjectPriority, Repo}

  schema "tasks" do
    field :name, :string
    field :description, :string

    belongs_to :project, Project
    belongs_to :status, ProjectStatus
    belongs_to :priority, ProjectPriority
    belongs_to :author, User
    has_many :events, TaskEvent

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

  def preloaded() do
    [:project, :status, :priority, :author, events: [:author]]
  end

  def preload_all(query) do
    events_query = from e in TaskEvent, order_by: e.inserted_at, preload: :author

    from t in query, preload: [:project, :status, :priority, :author, events: ^events_query]
  end

  def priorities() do
    [
      %{id: 1, name: "Low"},
      %{id: 2, name: "Normal"},
      %{id: 3, name: "High"},
    ]
  end

  def make_event(task, type, message) do
    task
    |> build_assoc(:events)
    |> TaskEvent.changeset(%{type: type, message: message})
  end

  defp changeset_fields(struct, params, required_fields, optional_fields) do
    struct
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
