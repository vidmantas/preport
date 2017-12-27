defmodule Preport.Youtrack do
  use HTTPoison.Base

  def process_url(filter) do
    "https://youtrack.toptal.net/youtrack/rest/issue?filter=#{filter}&max=50"
  end

  def process_response_body(body) do
    Poison.decode!(body)["issue"]
  end

  defp process_request_headers(headers) do
    token = Application.get_env(:preport, :youtrack_auth_token)
    Enum.into(headers, ["Authorization": "Bearer #{token}", "Accept": "Application/json; Charset=utf-8"])
  end
end
