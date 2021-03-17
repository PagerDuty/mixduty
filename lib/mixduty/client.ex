defmodule Mixduty.Client do
  alias __MODULE__
  defstruct headers: nil

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
    %Client{
      headers: [
        {"Accept", "application/vnd.pagerduty+json;version=2"},
        {"Authorization", "Bearer #{auth}"},
        {"Content-type", "application/json"}
      ]
    }
  end
end
