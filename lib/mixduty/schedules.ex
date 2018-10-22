defmodule Mixduty.Schedules do
  import Mixduty
  @path "schedules"

  @moduledoc """
  An on-call schedule determines the time periods that users are on call. Only on-call users are eligible to receive notifications from incidents.

  The details of the on-call schedule specify which single user is on call for that schedule at any given point in time. An on-call schedule consists of one or more schedule layers that rotate a group of users through the same shift at a set interval.

  Restrictions on each schedule layer limit on-call responsibility for that layer to certain times of the day or week. The period of time during which a user is present on a schedule layer is called a schedule layer entry.

  The ordered composition of schedule layers, combined with any schedule layer entries from the override layer, known as overrides, results in the final schedule layer. The final schedule layer represents the computed set of schedule layer entries that put users on call for the schedule, and cannot be modified directly.

  Schedules are used by escalation policies as an escalation target for a given escalation rule.


  """

  @doc """
  List schedules
  #### Example
      Mixduty.ExtensionPolicies.list(client)
  """
  def list(client, params \\ [], options \\ []) do
    get("#{@path}", client, params, options)
  end
end
