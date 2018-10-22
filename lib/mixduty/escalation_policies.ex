defmodule Mixduty.EscalationPolicies do
  import Mixduty
  @path "escalation_policies"

  @moduledoc """
  Escalation policies make sure the right people are alerted at the right time.

  An escalation policy determines what user or schedule will be notified first, second, and so on when an incident is triggered. Escalation policies are used by one or more services.
  """

  @doc """
  List escalation policies
  #### Example
      Mixduty.ExtensionPolicies.list(client)
  """
  def list(client, params \\ [], options \\ []) do
    get("#{@path}", client, params, options)
  end
end
