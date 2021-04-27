defmodule Mixduty.Response do
  require Logger
  alias Mixduty.Error

  alias Jason, as: JSON

  @enforce_keys [:status_code, :body, :request, :request_url]

  defstruct [
    :body,
    :headers,
    :status_code,
    :request,
    :request_url
  ]

  @type headers ::
          [{atom(), binary()}]
          | [{binary(), binary()}]
          | %{required(binary()) => binary()}
          | any()

  @type t :: %__MODULE__{
          body: Map.t() | String.t(),
          headers: headers(),
          status_code: integer(),
          request: HTTPoison.Request.t(),
          request_url: binary() | any()
        }

  def new(
        {:ok,
         %HTTPoison.Response{
           status_code: code,
           body: body,
           headers: headers,
           request: request,
           request_url: request_url
         }}
      )
      when code in 200..299 and body in [nil, ""] do
    {:ok,
     %__MODULE__{
       body: %{},
       status_code: code,
       headers: headers,
       request: request,
       request_url: request_url
     }}
  end

  def new(
        {:ok,
         %HTTPoison.Response{
           status_code: code,
           body: body,
           headers: headers,
           request: request,
           request_url: request_url
         } = resp}
      )
      when code in 200..299 do
    case json_decode(body) do
      {:ok, decoded_body} ->
        {:ok,
         %__MODULE__{
           body: decoded_body,
           status_code: code,
           headers: headers,
           request: request,
           request_url: request_url
         }}

      {:error, error} ->
        {:error, %Error{message: "JSON parse error: #{error}", status_code: code, cause: resp}}
    end
  end

  def new({:ok, %HTTPoison.Response{headers: headers, status_code: code} = resp})
      when code in 400..599 do
    {:error,
     %Error{
       message: reason_from_status_header_or_code(headers, code),
       status_code: code,
       cause: resp
     }}
  end

  def new({:ok, %HTTPoison.Response{status_code: code} = resp}) do
    {:error, %Error{message: "Unhandled status code: #{code}", status_code: code, cause: resp}}
  end

  def new({:error, %HTTPoison.Error{reason: reason} = error}) do
    {:error, %Error{message: "HTTP request failed. Reason: #{inspect(reason)}", cause: error}}
  end

  ## Private

  # Recursively trims whitespaces before proceeding
  # to the next function clause matching
  defp json_decode(" " <> str), do: json_decode(str)

  defp json_decode(str)
       when is_binary(str)
       when str != "" do
    case JSON.decode(str) do
      {:ok, data} -> {:ok, data}
      {:error, error} -> {:error, JSON.DecodeError.message(error)}
    end
  end

  defp json_decode(_), do: nil

  defp reason_from_status_header_or_code(headers, code) do
    case Enum.find(headers, &match?({"Status", _}, &1)) do
      {"Status", status} -> status
      nil -> Plug.Conn.Status.reason_phrase(code)
    end
  end
end
