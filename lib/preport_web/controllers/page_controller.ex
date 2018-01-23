defmodule PreportWeb.PageController do
  use PreportWeb, :controller

  def index(conn, params) do
    done_issues = WeeklyReport.done_issues(params)
    in_progress_issues = WeeklyReport.in_progress_issues
    {start_date, end_date} = WeeklyReport.date_range(params)
    render conn, "index.html", done_issues: done_issues, in_progress_issues: in_progress_issues, start_date: start_date, end_date: end_date
  end
end
