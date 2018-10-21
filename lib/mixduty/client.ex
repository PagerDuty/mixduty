defmodule Mixduty.Client do
  alias __MODULE__
  defstruct headers: nil

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
