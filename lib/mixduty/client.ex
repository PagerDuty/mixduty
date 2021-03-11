defmodule Mixduty.Client do
  alias __MODULE__
  defstruct headers: nil

  @moduledoc """
  The client used to make requests to the PagerDuty v2 API
  """

  @doc """
  Create the client
  #### Examples
      Mixduty.Client.new("myauthtoken")
      Mixduty.Client.new("myauthtoken", [{"X-EARLY-ACCESS", "business-impact-early-access"}])
  """
  def new(auth, headers \\ []) do
    %Client{
      headers: [
        {"Accept", "application/vnd.pagerduty+json;version=2"},
        {"Authorization", "Token token=#{auth}"},
        {"Content-type", "application/json"}
      ] ++ headers
    }
  end

  @doc """
  Create the client for Bearer authorization token
  #### Examples
      Mixduty.Client.new(:bearer, "bearerauthtoken")
      Mixduty.Client.new(:bearer, "bearerauthtoken", [{"X-EARLY-ACCESS", "business-impact-early-access"}])
  """
  def new(:bearer, auth, headers \\ []) do
    %Client{
      headers: [
        {"Accept", "application/vnd.pagerduty+json;version=2"},
        {"Authorization", "Bearer #{auth}"},
        {"Content-type", "application/json"}
      ] ++ headers
    }
  end
end
