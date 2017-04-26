defmodule Scrumex.User do
  use Scrumex.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    # admin fields
    field :admin, :boolean

    # internal fields
    field :joined_at, Timex.Ecto.DateTime
    field :signed_in_at, Timex.Ecto.DateTime

    timestamps()
  end

  @derive {Poison.Encoder, only: [:id, :first_name, :last_name, :email]}
  @required_fields [:first_name, :last_name, :email, :password]
  @optional_fields [:encrypted_password]
  @admin_fields [:admin]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    changeset_fields(struct, params, @required_fields, @optional_fields)
  end

  def admin_changeset(struct, params \\ %{}) do
    changeset_fields(struct, params, @required_fields, @optional_fields ++ @admin_fields)
  end

  def sign_in_changeset(user) do
    change(user, %{
      signed_in_at: Timex.now,
      joined_at: (user.joined_at || Timex.now)
    })
  end

  defp changeset_fields(struct, params, required_fields, optional_fields) do
    struct
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "Password does not match")
    |> unique_constraint(:email, message: "Email already taken")
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
