defmodule ElixirLokaliseApi.TeamUserBillingDetailsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.TeamUserBillingDetails
  alias ElixirLokaliseApi.Model.TeamUserBillingDetails, as: DetailsModel

  setup_all do
    HTTPoison.start()
  end

  doctest TeamUserBillingDetails

  test "finds billing details" do
    use_cassette "billing_details_find" do
      team_id = 176_692
      {:ok, %DetailsModel{} = details} = TeamUserBillingDetails.find(team_id)

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
  end

  test "creates billing details" do
    use_cassette "billing_details_create" do
      team_id = 269_556

      data = %{
        billing_email: "hi@example.com",
        country_code: "LV",
        zip: "LV-0123"
      }

      {:ok, %DetailsModel{} = details} = TeamUserBillingDetails.create(team_id, data)

      assert details.zip == "LV-0123"
      assert details.country_code == "LV"
      assert details.billing_email == "hi@example.com"
    end
  end

  test "updates billing details" do
    use_cassette "billing_details_update" do
      team_id = 269_556

      data = %{
        billing_email: "updated@example.com",
        country_code: "LV",
        zip: "LV-7890"
      }

      {:ok, %DetailsModel{} = details} = TeamUserBillingDetails.update(team_id, data)

      assert details.zip == "LV-7890"
      assert details.country_code == "LV"
      assert details.billing_email == "updated@example.com"
    end
  end
end
