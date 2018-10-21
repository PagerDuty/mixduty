defmodule Mixduty do
  use HTTPoison.Base
  require Logger
  alias Mixduty.Client
  alias Poison, as: JSON

  @endpoint "https://api.pagerduty.com/"

  def get(path, client, params \\ [], options \\ []) do
    url = @endpoint <> path
    # TODO: Encode params to url
    raw_request(:get, url, client, options)
  end

  def raw_request(method, url, client \\ %{}, body \\ "", options \\ [])
  def raw_request(method, url, %Client{headers: headers}, body, options) do
    request!(method, url, body, headers, options)
    |> handle_response
  end

  def raw_request(_method, _url, _client, _body, _options) do
    {:error, "Client is incorrectly configured, initialize client with correct auth token"}
  end

  def handle_response(%HTTPoison.Response{status_code: 200, body: resp_body}) do
    JSON.Parser.parse(resp_body)
    |> parse_json
  end

  def handle_response(%HTTPoison.Response{headers: resp_headers}) do
    {:error, resp_headers}
  end

  def parse_json({:ok, parsed_response}) do
    %{
      status: 200,
      data: parsed_response
    }
  end

  def parse_json(err) do
    {:error, "Could not parse response", err}
  end
end
