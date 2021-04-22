defmodule Mixduty.Client do
  alias __MODULE__
  defstruct headers: nil

  @type t :: %__MODULE__{}

  @moduledoc """
  The client used to make requests to the PagerDuty v2 API
  """

  @doc """
  Create the client
  #### Example
      Mixduty.Client.new("myauthtoken")
  """
  def new(auth) do
    %Client{
      headers: [
        {"Accept", "application/vnd.pagerduty+json;version=2"},
        {"Authorization", "Token token=#{auth}"},
        {"Content-type", "application/json"}
      ]
    }
  end

  @doc """
  Create the client for Bearer authorization token
  #### Example
      Mixduty.Client.new("bearerauthtoken", [type: :bearer])
  """
  def new(auth, type: :bearer) do
    new(auth, type: :bearer, headers: [])
  end

  @doc """
  Internal use only
  Create the client for Bearer authorization token with additional headers
  #### Example
      Mixduty.Client.new("bearerauthtoken", [type: :bearer, headers: [{"X-EARLY-ACCESS", "business-impact-early-access"}])
  """
  def new(auth, type: :bearer, headers: additional_headers) do
    %Client{
      headers:
        [
          {"Accept", "application/vnd.pagerduty+json;version=2"},
          {"Authorization", "Bearer #{auth}"},
          {"Content-type", "application/json"}
        ] ++ additional_headers
    }
  end
end
