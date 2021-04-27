defmodule Mixduty.Error do
  @enforce_keys [:message]
  @derive {Inspect, except: [:request]}

  defstruct [
    :message,
    :cause
  ]

  @type t :: %__MODULE__{
          message: String.t(),
          cause: HTTPoison.Response.t() | HTTPoison.Error.t() | String.t()
        }
end
