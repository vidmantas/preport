defmodule WeeklyReport do
  def issues(params \\ %{}) do
    {start_date, end_date} = date_range(params)
    raw_issues = Preport.Youtrack.get!(search_query(start_date, end_date)).body
    Enum.map raw_issues, fn issue ->
      project = field_value(issue, "projectShortName")
      number = field_value(issue, "numberInProject")
      points = field_value(issue, "Story Points") |> points

      %{identifier: "#{project}-#{number}", title: field_value(issue, "summary"), points: points}
    end
  end

  def date_range(%{"year" => year, "week" => week}) do
    expand_to_week(String.to_integer(year), String.to_integer(week))
  end

  def date_range(%{"week" => week}) do
    {year, _} = :calendar.iso_week_number
    expand_to_week(year, String.to_integer(week))
  end

  def date_range(%{}) do
    {year, week} = :calendar.iso_week_number
    expand_to_week(year, week)
  end

  def expand_to_week(year, week) do
    base = Timex.to_date({year, 1, 1}) |> Timex.shift(weeks: week)
    start_date = base |> Timex.beginning_of_week
    end_date = base |> Timex.end_of_week

    {start_date, end_date}
  end

  defp points(nil), do: 0
  defp points([head | _]), do: String.to_integer(head)

  defp field_value(issue, name) do
    field = Enum.filter(issue["field"], fn(x) -> x["name"] == name end) |> Enum.at(0)

    # not very Elixir-like part, but...
    if field do
      Map.get(field, "value")
    else
      nil
    end
  end

  defp search_query(start_date, end_date) do
    "Sprint:%20%7BTeam%20Enterprise%20Sales%20Ops%20Kanban%7D%20%23Done%20resolved%20date:%20#{start_date}%20..%20#{end_date}%20order%20by:%20%7Bissue%20id%7D%20desc"
  end
end
