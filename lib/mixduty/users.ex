defmodule Mixduty.Users do
  import Mixduty
  @path "users"

  @moduledoc """
  PagerDuty users are members of a PagerDuty account that have the ability to interact with incidents and other data on the account.

  Users are fundamental agents of different types of actions in PagerDuty. A user can, among other things:
  * acknowlege, reassign, snooze, escalate, and resolve incidents
  * configure services, escalation policies, integrations, on-call schedules, teams, and more
  * go on call for one or more schedules or escalation policies
  * receive notifications

  Depending on a user's role, he or she may have access to different parts of the account's data.
  """

  @doc """
  List users of an account
  #### Example
      Mixduty.Users.list(client)
  """
  def list(client, params \\ [], options \\ []) do
    get("#{@path}", client, params, options)
  end

  @doc """
  Get a users of an account
  #### Example
      Mixduty.Users.user("P00PBUG", client)
  """
  def user(id, client, params \\ [], options \\ []) do
    get("#{@path}/#{id}", client, params, options)
  end

  @doc """
  Create a new user
  #### Example
      Mixduty.Users.create("Test User", "test@user.com", client)
  """
  def create(name, email, client) do
    body = %{
      name: name,
      email: email
    }
    post("#{@path}", client, body)
  end

  @doc """
  Delete an existing user
  #### Example
      Mixduty.Users.delete("P00PBUG", client)
  """
  def remove(id, client) do
    delete("#{@path}/#{id}", client)
  end

  @doc """
  Update an existing user object
  #### Example
      Mixduty.Users.update("P00PBUG", %{name: "Test User"}, client)
  """
  def update(id, user_object, client) do
    put("#{@path}/#{id}", client, user_object)
  end
end
