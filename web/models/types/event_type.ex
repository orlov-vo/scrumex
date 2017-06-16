defmodule Scrumex.EventType do
  @behaviour Ecto.Type
  @types [info: 0, comment: 1]

  def type, do: :integer

  def cast(atom) when is_atom(atom), do: Keyword.fetch(@types, atom)
  def cast(integer) when is_integer(integer), do: {:ok, integer}
  def cast(_), do: :error

  def load(integer) when is_integer(integer) do
    case Enum.find(@types, fn({_, x}) -> x == integer end) do
      {atom, _} when is_atom(atom) -> {:ok, atom}
      _ -> :error
    end
  end

  def dump(atom) when is_atom(atom), do: Keyword.fetch(@types, atom)
  def dump(integer) when is_integer(integer), do: {:ok, integer}
  def dump(_), do: :error
end
