defmodule PreportWeb.PageController do
  use PreportWeb, :controller

  def index(conn, %{"year" => year, "week" => week}) do
    render conn, "index.html", issues: issues(year, week)
  end

  def index(conn, %{"week" => week}) do
    {year, _} = :calendar.iso_week_number
    render conn, "index.html", issues: issues(year, String.to_integer(week))
  end

  def index(conn, _params) do
    {year, week} = :calendar.iso_week_number
    render conn, "index.html", issues: issues(String.to_integer(year), String.to_integer(week))
  end

  defp issues(year, week) do
    raw_issues = Preport.Youtrack.get!(search_query(year, week)).body
    Enum.map raw_issues, fn issue ->
      project = field_value(issue, "projectShortName")
      number = field_value(issue, "numberInProject")

      %{identifier: "#{project}-#{number}", title: field_value(issue, "summary")}
    end
  end

  defp field_value(issue, name) do
    Enum.filter(issue["field"], fn(x) -> x["name"] == name end)
      |> Enum.at(0)
      |> Map.get("value")
  end

  defp search_query(year, week) do
    base = Timex.to_date({year, 1, 1}) |> Timex.shift(weeks: week)
    start_date = base |> Timex.beginning_of_week
    end_date = base |> Timex.end_of_week
    "Sprint:%20%7BTeam%20Enterprise%20Sales%20Ops%20Kanban%7D%20%23Done%20resolved%20date:%20#{start_date}%20..%20#{end_date}%20order%20by:%20%7Bissue%20id%7D%20desc"
  end
end
