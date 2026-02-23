defmodule ElixirLokaliseApi.TeamUserBillingDetailsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.TeamUserBillingDetails
  alias ElixirLokaliseApi.Model.TeamUserBillingDetails, as: DetailsModel

  doctest TeamUserBillingDetails

  @team_id 176_692

  test "finds billing details" do
    response = %{
      company: "Self-employed",
      address1: "Sample line 1",
      address2: "Sample line 2",
      city: "Riga",
      zip: "LV-6543",
      phone: "+371123456",
      vatnumber: "123",
      country_code: "LV",
      billing_email: "hello@example.com",
      state_code: ""
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/billing_details")

      response
      |> ok()
    end)

    {:ok, %DetailsModel{} = details} = TeamUserBillingDetails.find(@team_id)

    assert details.billing_email == "hello@example.com"
    assert details.country_code == "LV"
    assert details.zip == "LV-6543"
    assert details.state_code == ""
    assert details.address1 == "Sample line 1"
    assert details.address2 == "Sample line 2"
    assert details.city == "Riga"
    assert details.phone == "+371123456"
    assert details.company == "Self-employed"
    assert details.vatnumber == "123"
  end

  test "creates billing details" do
    data = %{
      billing_email: "hi@example.com",
      country_code: "LV",
      zip: "LV-0123"
    }

    response = %{
      zip: "LV-0123",
      country_code: "LV",
      billing_email: "hi@example.com"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/billing_details", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %DetailsModel{} = details} = TeamUserBillingDetails.create(@team_id, data)

    assert details.zip == "LV-0123"
    assert details.country_code == "LV"
    assert details.billing_email == "hi@example.com"
  end

  test "updates billing details" do
    data = %{
      billing_email: "updated@example.com",
      country_code: "LV",
      zip: "LV-7890"
    }

    response = %{
      zip: "LV-7890",
      country_code: "LV",
      billing_email: "updated@example.com"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/billing_details", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %DetailsModel{} = details} = TeamUserBillingDetails.update(@team_id, data)

    assert details.zip == "LV-7890"
    assert details.country_code == "LV"
    assert details.billing_email == "updated@example.com"
  end
end
