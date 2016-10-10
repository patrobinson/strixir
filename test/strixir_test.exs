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
  \"distance\": 4475.4,
  \"moving_time\": 1303,
  \"elapsed_time\": 1333,
  \"total_elevation_gain\": 154.5,
  \"elev_high\": 331.4,
  \"elev_low\": 276.1,
  \"type\": \"Run\",
  \"start_date\": \"2012-12-13T03:43:19Z\",
  \"start_date_local\": \"2012-12-12T19:43:19Z\",
  \"timezone\": \"(GMT-08:00) America/Los_Angeles\",
  \"start_latlng\": [
    37.8,
    -122.27
  ],
  \"end_latlng\": [
    37.8,
    -122.27
  ],
  \"achievement_count\": 6,
  \"kudos_count\": 1,
  \"comment_count\": 1,
  \"athlete_count\": 1,
  \"photo_count\": 0,
  \"total_photo_count\": 0,
  \"photos\": {
    \"count\": 2,
    \"primary\": {
      \"id\": null,
      \"source\": 1,
      \"unique_id\": \"d64643ec9205\",
      \"urls\": {
        \"100\": \"http://pics.com/28b9d28f-128x71.jpg\",
        \"600\": \"http://pics.com/28b9d28f-768x431.jpg\"
      }
    }
  },
  \"map\": {
    \"id\": \"a32193479\",
    \"polyline\": \"kiteFpCBCD]\",
    \"summary_polyline\": \"{cteFjcaBkCx@gEz@\",
    \"resource_state\": 3
  },
  \"trainer\": false,
  \"commute\": false,
  \"manual\": false,
  \"private\": false,
  \"flagged\": false,
  \"workout_type\": 2,
  \"gear\": {
    \"id\": \"g138727\",
    \"primary\": true,
    \"name\": \"Nike Air\",
    \"distance\": 88983.1,
    \"resource_state\": 2
  },
  \"average_speed\": 3.4,
  \"max_speed\": 4.514,
  \"calories\": 390.5,
  \"has_kudoed\": false,
  \"segment_efforts\": [
    {
      \"id\": 543755075,
      \"resource_state\": 2,
      \"name\": \"Dash for the Ferry\",
      \"segment\": {
        \"id\": 2417854,
        \"resource_state\": 2,
        \"name\": \"Dash for the Ferry\",
        \"activity_type\": \"Run\",
        \"distance\": 1055.11,
        \"average_grade\": -0.1,
        \"maximum_grade\": 2.7,
        \"elevation_high\": 4.7,
        \"elevation_low\": 2.7,
        \"start_latlng\": [
          37.7905785,
          -122.27015622
        ],
        \"end_latlng\": [
          37.79536649,
          -122.2796434
        ],
        \"climb_category\": 0,
        \"city\": \"Oakland\",
        \"state\": \"CA\",
        \"country\": \"United States\",
        \"private\": false
      },
      \"activity\": {
        \"id\": 32193479,
        \"resource_state\": 1
      },
      \"athlete\": {
        \"id\": 3776,
        \"resource_state\": 1
      },
      \"kom_rank\": 2,
      \"pr_rank\": 1,
      \"elapsed_time\": 304,
      \"moving_time\": 304,
      \"start_date\": \"2012-12-13T03:48:14Z\",
      \"start_date_local\": \"2012-12-12T19:48:14Z\",
      \"distance\": 1052.33,
      \"start_index\": 5348,
      \"end_index\": 6485,
      \"hidden\": false,
      \"achievements\": [
        {
          \"type_id\": 2,
          \"type\": \"overall\",
          \"rank\": 2
        },
        {
          \"type_id\": 3,
          \"type\": \"pr\",
          \"rank\": 1
        }
      ]
    }
  ],
  \"splits_metric\": [
    {
      \"distance\": 1002.5,
      \"elapsed_time\": 276,
      \"elevation_difference\": 0,
      \"moving_time\": 276,
      \"split\": 1
    },
    {
      \"distance\": 475.7,
      \"elapsed_time\": 139,
      \"elevation_difference\": 0,
      \"moving_time\": 139,
      \"split\": 5
    }
  ],
  \"splits_standard\": [
    {
      \"distance\": 1255.9,
      \"elapsed_time\": 382,
      \"elevation_difference\": 3.2,
      \"moving_time\": 382,
      \"split\": 3
    }
  ],
  \"best_efforts\": [
    {
      \"id\": 273063933,
      \"resource_state\": 2,
      \"name\": \"400m\",
      \"segment\": null,
      \"activity\": {
        \"id\": 32193479
      },
      \"athlete\": {
        \"id\": 3776
      },
      \"kom_rank\": null,
      \"pr_rank\": null,
      \"elapsed_time\": 105,
      \"moving_time\": 106,
      \"start_date\": \"2012-12-13T03:43:19Z\",
      \"start_date_local\": \"2012-12-12T19:43:19Z\",
      \"distance\": 400,
      \"achievements\": [

      ]
    },
    {
      \"id\": 273063935,
      \"resource_state\": 2,
      \"name\": \"1/2 mile\",
      \"segment\": null,
      \"activity\": {
        \"id\": 32193479
      },
      \"athlete\": {
        \"id\": 3776
      },
      \"kom_rank\": null,
      \"pr_rank\": null,
      \"elapsed_time\": 219,
      \"moving_time\": 220,
      \"start_date\": \"2012-12-13T03:43:19Z\",
      \"start_date_local\": \"2012-12-12T19:43:19Z\",
      \"distance\": 805,
      \"achievements\": [

      ]
    }
  ]
}
"
  @api_endpoint "https://www.strava.com/api/v3/"

  def request!(:get, url, _body, _headers, _options) do
    response = case url do
      "#{@api_endpoint}athletes/12345678/activities?page=1&per_page=200" -> [JSX.decode!(@activity_response)]
      "#{@api_endpoint}athletes/12345678/activities?page=2&per_page=200" -> []
    end

    %HTTPoison.Response{ status_code: 200,
                                                 headers: %{},
                                                 body: response }
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
        "total_photo_count" => 0,
        "end_latlng" => [37.8, -122.27],
        "start_latlng" => [37.8, -122.27],
        "resource_state" => 3,
        "timezone" => "(GMT-08:00) America/Los_Angeles",
        "start_date" => "2012-12-13T03:43:19Z",
        "athlete" => %{"id" => 227615, "resource_state" => 1},
        "photos" => %{
          "count" => 2,
          "primary" => %{
            "id" => nil,
            "source" => 1,
            "unique_id" => "d64643ec9205",
            "urls" => %{"100" => "http://pics.com/28b9d28f-128x71.jpg", "600" => "http://pics.com/28b9d28f-768x431.jpg"}
          }
        },
        "calories" => 390.5,
        "id" => 321934,
        "athlete_count" => 1,
        "best_efforts" => [
          %{
            "achievements" => [],
            "activity" => %{"id" => 32193479},
            "athlete" => %{"id" => 3776},
            "distance" => 400,
            "elapsed_time" => 105,
            "id" => 273063933,
            "kom_rank" => nil,
            "moving_time" => 106,
            "name" => "400m",
            "pr_rank" => nil,
            "resource_state" => 2,
            "segment" => nil,
            "start_date" => "2012-12-13T03:43:19Z",
            "start_date_local" => "2012-12-12T19:43:19Z"
          },
          %{
            "achievements" => [],
            "activity" => %{"id" => 32193479},
            "athlete" => %{"id" => 3776},
            "distance" => 805,
            "elapsed_time" => 219,
            "id" => 273063935,
            "kom_rank" => nil,
            "moving_time" => 220,
            "name" => "1/2 mile",
            "pr_rank" => nil,
            "resource_state" => 2,
            "segment" => nil,
            "start_date" => "2012-12-13T03:43:19Z",
            "start_date_local" => "2012-12-12T19:43:19Z"
          }
        ],
        "external_id" => "2012-12-12_21-40-32-80-29011.fit",
        "kudos_count" => 1,
        "elev_low" => 276.1,
        "manual" => false,
        "gear" => %{
          "distance" => 88983.1,
          "id" => "g138727",
          "name" => "Nike Air",
          "primary" => true, "resource_state" => 2
        },
        "type" => "Run",
        "commute" => false,
        "flagged" => false,
        "start_date_local" => "2012-12-12T19:43:19Z",
        "average_speed" => 3.4,
        "name" => "Evening Ride",
        "private" => false,
        "distance" => 4475.4,
        "max_speed" => 4.514,
        "moving_time" => 1303,
        "photo_count" => 0,
        "trainer" => false,
        "has_kudoed" => false,
        "total_elevation_gain" => 154.5,
        "splits_standard" => [
          %{
            "distance" => 1255.9,
            "elapsed_time" => 382,
            "elevation_difference" => 3.2,
            "moving_time" => 382, "split" => 3
          }
        ],
        "description" => "the best ride ever",
        "segment_efforts" => [
          %{
            "achievements" => [
              %{
                "rank" => 2,
                "type" => "overall",
                "type_id" => 2
              },
              %{
                "rank" => 1,
                "type" => "pr",
                "type_id" => 3
              }
            ],
            "activity" => %{
              "id" => 32193479,
              "resource_state" => 1
            },
            "athlete" => %{
              "id" => 3776,
              "resource_state" => 1
            },
            "distance" => 1052.33,
            "elapsed_time" => 304,
            "end_index" => 6485,
            "hidden" => false,
            "id" => 543755075,
            "kom_rank" => 2,
            "moving_time" => 304,
            "name" => "Dash for the Ferry",
            "pr_rank" => 1,
            "resource_state" => 2,
            "segment" => %{
              "activity_type" => "Run",
              "average_grade" => -0.1,
              "city" => "Oakland",
              "climb_category" => 0,
              "country" => "United States",
              "distance" => 1055.11,
              "elevation_high" => 4.7,
              "elevation_low" => 2.7,
              "end_latlng" => [37.79536649, -122.2796434],
              "id" => 2417854,
              "maximum_grade" => 2.7,
              "name" => "Dash for the Ferry",
              "private" => false,
              "resource_state" => 2,
              "start_latlng" => [37.7905785, -122.27015622],
              "state" => "CA"
            },
            "start_date" => "2012-12-13T03:48:14Z",
            "start_date_local" => "2012-12-12T19:48:14Z",
            "start_index" => 5348
          }
        ],
        "elapsed_time" => 1333,
        "splits_metric" => [
          %{
            "distance" => 1002.5,
            "elapsed_time" => 276,
            "elevation_difference" => 0,
            "moving_time" => 276,
            "split" => 1
          },
          %{
            "distance" => 475.7,
            "elapsed_time" => 139,
            "elevation_difference" => 0,
            "moving_time" => 139, "split" => 5
          }
        ],
        "elev_high" => 331.4,
        "comment_count" => 1,
        "achievement_count" => 6,
        "workout_type" => 2,
        "map" => %{
          "id" => "a32193479",
          "polyline" => "kiteFpCBCD]",
          "resource_state" => 3,
          "summary_polyline" => "{cteFjcaBkCx@gEz@"
        },
        "upload_id" => 361720
      }
    ]
  end
end
