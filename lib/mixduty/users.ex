defmodule Mixduty.Users do
  import Mixduty

  @moduledoc """
  List users of your PagerDuty account
  """

  def list(client, params \\ [], options \\ []) do
    get("users", client, params, options)
  end

  def user(id, client, params \\ [], options \\ []) do
    get("users/#{id}", client, params, options)
  end
end