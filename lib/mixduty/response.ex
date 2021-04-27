defmodule Mixduty.Response do
  require Logger
  alias Mixduty.Error

  alias Jason, as: JSON

  @enforce_keys [:body, :headers, :status_code, :request, :request_url]

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

  def new({:ok, %HTTPoison.Response{status_code: code, body: body} = resp})
      when code in 200..299 and body in [nil, ""] do
    resp
    |> Map.from_struct()
    |> Map.put(:body, %{})
    |> put_into(__MODULE__)
  end

  def new({:ok, %HTTPoison.Response{status_code: code, body: body} = resp})
      when code in 200..299 do
    case json_decode(body) do
      {:ok, decoded_body} ->
        resp
        |> Map.from_struct()
        |> Map.put(:body, decoded_body)
        |> put_into(__MODULE__)

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

  def put_into(response, struct_name_or_map, opts \\ [])

  def put_into({:ok, %__MODULE__{body: body}}, %{} = map, opts),
    do:
      {:ok,
       Map.merge(
         map,
         body
         |> extract_from_container(opts[:container])
         |> Morphix.atomorphiform!()
       )}

  def put_into({:ok, %__MODULE__{body: body}}, struct_name, opts),
    do:
      {:ok,
       struct(
         struct_name,
         body
         |> extract_from_container(opts[:container])
         |> Morphix.atomorphiform!()
       )}

  def put_into(%{} = map, struct_name, _opts), do: {:ok, struct(struct_name, map)}

  def put_into(error, _module, _opts), do: error

  def put_all_into(response, struct_name_or_map, opts \\ [])

  def put_all_into({:ok, %__MODULE__{body: body}}, %{} = map, opts) do
    {
      :ok,
      body
      |> extract_from_container(opts[:container])
      |> Enum.map(fn item -> Map.merge(map, Morphix.atomorphiform!(item)) end)
    }
  end

  def put_all_into({:ok, %__MODULE__{body: body}}, struct_name, opts) do
    {
      :ok,
      body
      |> extract_from_container(opts[:container])
      |> Enum.map(fn item -> struct(struct_name, Morphix.atomorphiform!(item)) end)
    }
  end

  def put_all_into(error, _module, _opts), do: error

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

  defp extract_from_container(body, nil = _container_name), do: body

  defp extract_from_container(body, container_name), do: get_in(body, [container_name])
end
