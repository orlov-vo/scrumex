defmodule Scrumex.Project do
  use Scrumex.Web, :model

  alias Scrumex.{User, Task, ProjectStatus, ProjectPriority, Repo}

  schema "projects" do
    field :name, :string
    field :slug, :string

    belongs_to :owner, User

    has_many :tasks, Task
    has_many :statuses, ProjectStatus
    has_many :priorities, ProjectPriority

    timestamps()
  end

  @required_fields [:name, :owner_id]
  @optional_fields [:slug]

  def changeset(struct, params \\ %{}) do
    changeset_fields(struct, params, @required_fields, @optional_fields)
  end

  def create_changeset(struct, params \\ %{}) do
    new_params = params
    |> Map.put("statuses", [
      %{name: "Backlog"},
      %{name: "In progress"},
      %{name: "Done"},
    ])
    |> Map.put("priorities", [
      %{name: "Critical"},
      %{name: "Major"},
      %{name: "Trivial"},
    ])

    struct
    |> changeset(new_params)
    |> cast_assoc(:statuses)
    |> cast_assoc(:priorities)
  end

  def preloaded() do
    [:owner, tasks: [:author], statuses: [tasks: [:author]], priorities: [tasks: [:author]]]
  end

  def preload_all(query) do
    tasks_query = from t in Task, order_by: t.position, preload: :author
    statuses_query = from ps in ProjectStatus, order_by: ps.position, preload: [tasks: ^tasks_query]
    priorities_query = from pp in ProjectPriority, order_by: pp.position, preload: [tasks: ^tasks_query]

    from p in query, preload: [:owner, tasks: ^tasks_query, statuses: ^statuses_query, priorities: ^priorities_query]
  end

  def slug_id(project) do
    "#{project.id}-#{project.slug}"
  end

  def parse_slug_id(slug_id) do
    slug_id
    |> String.split("-", parts: 2)
    |> List.update_at(0, &(String.to_integer(&1)))
    |> List.to_tuple()
  end

  def get_from_slug_id(slug_id) do
    project_id = slug_id
    |> parse_slug_id()
    |> elem(0)

    Repo.get!(__MODULE__, project_id)
  end

  def statuses(project) do
    [
      %{id: 1, name: "Backlog"},
      %{id: 2, name: "Design"},
      %{id: 3, name: "Develop"},
      %{id: 4, name: "QA"},
      %{id: 5, name: "Deploy"},
    ]
  end

  defp changeset_fields(struct, params, required_fields, optional_fields) do
    struct
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> slugify_name()
  end

  defp slugify_name(current_changeset) do
    if name = get_change(current_changeset, :name) do
      put_change(current_changeset, :slug, Slugger.slugify_downcase(name))
    else
      current_changeset
    end
  end
end

defimpl Phoenix.Param, for: Scrumex.Project do
  def to_param(project) do
    Scrumex.Project.slug_id(project)
  end
end
