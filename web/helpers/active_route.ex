defmodule Scrumex.Helper.ActiveRoute do
  def active_path(conn, path, class) do
    active_path(conn, path, class, "is-active")
  end

  def active_path(conn, path, class, active) do
    current_path = Path.join(["/" | conn.path_info])
    if path == current_path, do: "#{class} #{active}", else: class
  end
end
