defmodule Mixduty.Teams do
  import Mixduty
  @path "teams"

  @moduledoc """
  A team is a collection of users and escalation policies that represent a group of people within an organization.

  Teams can be used throughout the API and PagerDuty applications to filter information to only what is relevant for one or more teams.

  The account must have the teams ability to use the following endpoints.

  """

  @doc """
  List teams
  #### Example
      Mixduty.Team.list(client)
  """
  def list(client, params \\ [], options \\ []) do
    get("#{@path}", client, params, options)
  end
end
