defmodule Scrumex.Meta.Title do
  alias Scrumex.{PageView}

  @suffix "Scrumex"

  def page_title(assigns), do: assigns |> get |> put_suffix

  # no need for the suffix on these
  def share_title(assigns), do: assigns |> get

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title <> " | " <> @suffix

  defp get(%{view_module: PageView, view_template: template}) do
    case template do
      "home.html"      -> nil
      _else ->
        template
        |> String.replace(".html", "")
        |> String.split("_")
        |> Enum.map(fn(s) -> String.capitalize(s) end)
        |> Enum.join(" ")
    end
  end

  defp get(_), do: nil
end
