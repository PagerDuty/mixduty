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
end
