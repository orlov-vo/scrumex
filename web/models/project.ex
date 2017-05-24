defmodule Scrumex.Project do
  use Scrumex.Web, :model

  schema "projects" do
    field :name, :string
    field :slug, :string

    belongs_to :owner, Scrumex.User

    timestamps()
  end

  @required_fields [:name, :owner_id]
  @optional_fields [:slug]

  def changeset(struct, params \\ %{}) do
    changeset_fields(struct, params, @required_fields, @optional_fields)
  end

  def preload_all(query) do
    # comments_query = from c in Comment, order_by: [desc: c.inserted_at], preload: :user
    # cards_query = from c in Card, order_by: c.position, preload: [[comments: ^comments_query], :members]
    # lists_query = from l in List, order_by: l.position, preload: [cards: ^cards_query]

    from b in query, preload: [:owner]
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
