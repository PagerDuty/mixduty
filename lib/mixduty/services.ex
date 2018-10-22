defmodule Mixduty.Services do
  import Mixduty
  @path "services"

  @moduledoc """
  A PagerDuty service represents something you monitor (like a web service, email service, or database service). It is a container for related incidents that associates them with escalation policies.

  A service is the focal point for incident management; services specify the configuration for the behavior of incidents triggered on them. This behavior includes specifying urgency and performing automated actions based on time of day, incident duration, and other factors.
  """

  @doc """
  List services
  #### Example
      Mixduty.Services.list(client)
  """
  def list(client, params \\ [], options \\ []) do
    get("#{@path}", client, params, options)
  end
end
