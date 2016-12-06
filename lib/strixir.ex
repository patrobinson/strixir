defmodule Strixir do
  use HTTPoison.Base
  use Application
  require Logger

  @http_client Application.get_env(:strixir, :http_client, HTTPoison)

  @user_agent [{"User-agent", "strixir"}]

  @type response :: {integer, any} | :jsx.json_term

  def start(_type, _args) do
    Strixir.Supervisor.start_link()
  end

  @spec process_response(HTTPoison.Response.t) :: response
  def process_response(%HTTPoison.Response{status_code: 200, body: body}), do: body
  def process_response(%HTTPoison.Response{status_code: status_code, body: body }), do: { status_code, body }

  def get(path, client) do
    _request(:get, path, client)
  end

  def get_async(path, client) do
    request_with_pagination(:get, path, client, "", true)
  end

  def _request(method, path, client, body \\ "") do
    json_request(method, urlify(client.endpoint, path), body, authorization_header(client.auth, @user_agent))
  end

  def request_with_pagination(method, path, client, body \\ "", rate_limiting \\ false) do
    url = client.endpoint |> urlify(path) |> add_params_to_url([per_page: 200])
    headers = authorization_header(client.auth, @user_agent)
    response = request_with_page(method, url, body, headers, 1, [], rate_limiting)
  end

  def request_with_page(method, url, body, headers, page, acc, false) do
    request_url = url |> add_params_to_url([page: page])
    Logger.debug "Requesting #{request_url}"
    case json_request(method, request_url, body, headers) |> process_paginated_response do
      {false, response} ->
        Logger.debug "Got response #{inspect response}"
        acc
      {true, response} ->
        Logger.debug "Got response #{inspect response}"
        request_with_page(method, url, body, headers, page + 1, response ++ acc, false)
    end
  end

  def request_with_page(method, url, body, headers, page, acc, true) do
    request_url = url |> add_params_to_url([page: page])
    Logger.debug "Queuing request #{request_url}"
    GenServer.call(RateLimiting, :push, [method, request_url, body, headers])
    response = case Strixir.AsyncRequests.work do
      nil ->
        raise "No work to process"
      r -> r
    end
    case response |> process_paginated_response do
      {false, response} ->
        Logger.debug "Got response #{inspect response}"
        acc
      {true, response} ->
        Logger.debug "Got response #{inspect response}"
        request_with_page(method, url, body, headers, page + 1, response ++ acc, true)
    end
  end

  def process_paginated_response(response) do
    case response do
      response when response == [] ->
        Logger.debug "Got response #{inspect response}"
        {false, nil}
      response                     ->
        Logger.debug "Got response #{inspect response}"
        {true, response}
    end
  end

  defp urlify(endpoint, path) do
    "#{endpoint}#{path}"
  end

  def json_request(method, url, body \\ "", headers \\ [], options \\ []) do
    raw_request(method, url, JSX.encode!(body), headers, options)
  end

  defp raw_request(method, url, body \\ "", headers \\ [], options \\ []) do
    @http_client.request!(method, url, body, headers, options) |> process_response
  end

  defp authorization_header(%{access_token: token}, headers) do
    headers ++ [{"Authorization", "Bearer #{token}"}]
  end

  defp authorization_header(nil, headers) do
    headers
  end

  @doc """
  Taken from edgurgel/tentacat

  Take an existing URI and add addition params, appending and replacing as necessary
  ## Examples
      iex> add_params_to_url("http://example.com/wat", [])
      "http://example.com/wat"
      iex> add_params_to_url("http://example.com/wat", [q: 1])
      "http://example.com/wat?q=1"
      iex> add_params_to_url("http://example.com/wat", [q: 1, t: 2])
      "http://example.com/wat?q=1&t=2"
      iex> add_params_to_url("http://example.com/wat", %{q: 1, t: 2})
      "http://example.com/wat?q=1&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1&t=2", [])
      "http://example.com/wat?q=1&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1", [t: 2])
      "http://example.com/wat?q=1&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1", [q: 3, t: 2])
      "http://example.com/wat?q=3&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1&s=4", [q: 3, t: 2])
      "http://example.com/wat?q=3&s=4&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1&s=4", %{q: 3, t: 2})
      "http://example.com/wat?q=3&s=4&t=2"
  """
  @spec add_params_to_url(binary, list) :: binary
  def add_params_to_url(url, params) do
    url
    |> URI.parse
    |> merge_uri_params(params)
    |> String.Chars.to_string
  end

  @spec merge_uri_params(URI.t, list) :: URI.t
  defp merge_uri_params(uri, []), do: uri
  defp merge_uri_params(%URI{query: nil} = uri, params) when is_list(params) or is_map(params) do
    uri
    |> Map.put(:query, URI.encode_query(params))
  end
  defp merge_uri_params(%URI{} = uri, params) when is_list(params) or is_map(params) do
    uri
    |> Map.update!(:query, fn q -> q |> URI.decode_query |> Map.merge(param_list_to_map_with_string_keys(params)) |> URI.encode_query end)
  end

  @spec param_list_to_map_with_string_keys(list) :: map
  defp param_list_to_map_with_string_keys(list) when is_list(list) or is_map(list) do
    for {key, value} <- list, into: Map.new do
      {"#{key}", value}
    end
  end
end
