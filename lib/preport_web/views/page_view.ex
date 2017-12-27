defmodule PreportWeb.PageView do
  use PreportWeb, :view

  def total_points(issues) do
    Enum.reduce(issues, 0, fn(issue, acc) -> issue[:points] + acc end)
  end
end
