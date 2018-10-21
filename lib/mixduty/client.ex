defmodule Mixduty.Client do
  alias __MODULE__
  defstruct headers: nil

  def new(auth) do
    %Client{
      headers: %{
        accept: "application/vnd.pagerduty+json;version=2",
        authorization: "Token token=#{auth}"
      }
    }
  end
end