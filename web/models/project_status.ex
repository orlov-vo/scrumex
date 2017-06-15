defmodule Scrumex.ProjectStatus do
  use Scrumex.Web, :model

  require Logger

  alias Scrumex.{Project, Task, Repo}

  schema "project_statuses" do
    field :name, :string
    field :position, :integer

    belongs_to :project, Project
    has_many :tasks, Task, foreign_key: :status_id
  end

  @required_fields [:name, :project_id]
  @optional_fields [:position]

  def changeset(struct, params \\ %{}) do
    changeset_fields(struct, params, @required_fields, @optional_fields)
  end

  defp changeset_fields(struct, params, required_fields, optional_fields) do
    struct
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> calculate_position()
  end

  defp calculate_position(changeset) do
    if changeset.valid? do
      project_id = get_field(changeset, :project_id)

      query = from(ps in Scrumex.ProjectStatus,
        select: ps.position,
        where: ps.project_id == ^project_id,
        order_by: [desc: ps.position],
        limit: 1)

      case Repo.one(query) do
        nil      -> put_change(changeset, :position, 1024)
        position -> put_change(changeset, :position, position + 1024)
      end
    else
      changeset
    end
  end
end
