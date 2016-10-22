defmodule Strixir.HTTPoison.InMemory do
  @activity_response "
{
  \"id\": 321934,
  \"resource_state\": 3,
  \"external_id\": \"2012-12-12_21-40-32-80-29011.fit\",
  \"upload_id\": 361720,
  \"athlete\": {
    \"id\": 227615,
    \"resource_state\": 1
  },
  \"name\": \"Evening Ride\",
  \"description\": \"the best ride ever\",
  \"distance\": 4475.4
}
"
  @api_endpoint "https://www.strava.com/api/v3/"

  def request!(:get, url, _body, _headers, _options) do
    response = case url do
      "#{@api_endpoint}athletes/12345678/activities?page=1&per_page=200" -> [JSX.decode!(@activity_response)]
      "#{@api_endpoint}athletes/12345678/activities?page=2&per_page=200" -> []
      "#{@api_endpoint}athletes/async/activities?page=1&per_page=200" -> [JSX.decode!(@activity_response)]
      "#{@api_endpoint}athletes/async/activities?page=2&per_page=200" -> []
    end

    %HTTPoison.Response{ status_code: 200,
                                                 headers: %{},
                                                 body: response }
  end
end

defmodule Strixir.AsyncProcessor do
  def process(response) do
    IO.puts(Process.group_leader, (response |> IO.inspect))
  end
end

defmodule StrixirTest do
  use ExUnit.Case
  import Strixir

  doctest Strixir

  @client Strixir.Client.new

  test "get with pagination" do
    assert request_with_pagination(:get, "athletes/12345678/activities", @client) == [
      %{
        "resource_state" => 3,
        "id" => 321934,
        "external_id" => "2012-12-12_21-40-32-80-29011.fit",
        "name" => "Evening Ride",
        "distance" => 4475.4,
        "description" => "the best ride ever",
        "upload_id" => 361720,
        "athlete" => %{"id" => 227615, "resource_state" => 1}
      }
    ]
  end

  test "get async" do
    assert request_with_pagination(:get, "athletes/async/activities", @client, true) == [
      %{
        "resource_state" => 3,
        "id" => 321934,
        "external_id" => "2012-12-12_21-40-32-80-29011.fit",
        "name" => "Evening Ride",
        "distance" => 4475.4,
        "description" => "the best ride ever",
        "upload_id" => 361720,
        "athlete" => %{"id" => 227615, "resource_state" => 1}
      }
    ]
  end
end
