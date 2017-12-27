defmodule PreportWeb.PageController do
  use PreportWeb, :controller

  def index(conn, params) do
    issues = WeeklyReport.issues(params)
    {start_date, end_date} = WeeklyReport.date_range(params)
    render conn, "index.html", issues: issues, start_date: start_date, end_date: end_date
  end
end
