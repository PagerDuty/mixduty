defmodule Mixduty do
  use HTTPoison.Base
  require Logger
  alias Mixduty.Client
  alias Poison, as: JSON

  def get(path, client, params \\ [], options \\ []) do
    url = endpoint() <> path <> "?" <> URI.encode_query(params)

    raw_request(:get, url, client, options)
  end

  def post(path, client, body \\ "") do
    url = endpoint() <> path
    raw_request(:post, url, client, JSON.encode!(body))
  end

  def delete(path, client, body \\ "") do
    url = endpoint() <> path
    raw_request(:delete, url, client, JSON.encode!(body))
  end

  def put(path, client, body \\ "") do
    url = endpoint() <> path
    raw_request(:put, url, client, JSON.encode!(body))
  end

  def raw_request(method, url, client \\ %{}, body \\ "", options \\ [])
  def raw_request(method, url, %Client{headers: headers}, body, options) do
    request!(method, url, body, headers, options)
    |> handle_response
  end

  def raw_request(_method, _url, _client, _body, _options) do
    {:error, "Client is incorrectly configured, initialize client with correct auth token"}
  end

  def handle_response(%HTTPoison.Response{status_code: code, body: resp_body}) when code in 200..299 do
    case resp_body do
      "" -> {:ok, resp_body} |> parse_json(code)
      _ -> JSON.decode(resp_body) |> parse_json(code)
    end
  end

  def handle_response(err) do
    {:error, err}
  end

  def parse_json({:ok, parsed_response}, code) do
    %{
      status: code,
      data: parsed_response
    }
  end

  def parse_json({:error, err}, _) do
    {:error, "Could not parse response", err}
  end

  defp endpoint do
    Application.get_env(:mixduty, :base_url, "https://api.pagerduty.com/")
  end
end
