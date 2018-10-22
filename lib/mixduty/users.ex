defmodule Mixduty.Users do
  import Mixduty

  @moduledoc """
  List users of your PagerDuty account
  """

  @doc """
  List users of an account
  #### Example
      Mixduty.Users.list(client)
  """
  def list(client, params \\ [], options \\ []) do
    get("users", client, params, options)
  end

  @doc """
  Get a users of an account
  #### Example
      Mixduty.Users.user("P00PBUG", client)
  """
  def user(id, client, params \\ [], options \\ []) do
    get("users/#{id}", client, params, options)
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
    post("users", client, body)
  end

  @doc """
  Delete an existing user
  #### Example
      Mixduty.Users.delete("P00PBUG", client)
  """
  def remove(id, client) do
    delete("users/#{id}", client)
  end
end
