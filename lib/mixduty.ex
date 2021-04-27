defmodule Mixduty do
  require Logger
  alias Mixduty.Client
  alias Jason, as: JSON
  alias Mixduty.Response

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
    HTTPoison.request(method, url, body, headers, options)
    |> Response.new()
  end

  def raw_request(_method, _url, _client, _body, _options) do
    {:error, "Client is incorrectly configured, initialize client with correct auth token"}
  end

  defp endpoint do
    Application.get_env(:mixduty, :base_url, "https://api.pagerduty.com/")
  end
end
