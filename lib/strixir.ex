defmodule Strixir do
  use HTTPoison.Base

  @user_agent [{"User-agent", "strixir"}]

  @type response :: {integer, any} | :jsx.json_term

  @spec process_response_body(binary) :: term
  def process_response_body(""), do: nil
  def process_response_body(body), do: JSX.decode!(body)

  @spec process_response(HTTPoison.Response.t) :: response
  def process_response(%HTTPoison.Response{status_code: 200, body: body}), do: body
  def process_response(%HTTPoison.Response{status_code: status_code, body: body }), do: { status_code, body }

  def get(url, access_token) do
    _request(:get, url, %{access_token: access_token})
  end

  def _request(method, url, auth, body \\ "") do
    json_request(method, url, body, authorization_header(auth, @user_agent))
  end

  def json_request(method, url, body \\ "", headers \\ [], options \\ []) do
    raw_request(method, url, JSX.encode!(body), headers, options)
  end

  def raw_request(method, url, body \\ "", headers \\ [], options \\ []) do
    request!(method, url, body, headers, options) |> process_response
  end

  def authorization_header(%{access_token: token}, headers) do
    headers ++ [{"Authorization", "Bearer #{token}"}]
  end
end
