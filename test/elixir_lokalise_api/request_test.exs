defmodule ElixirLokaliseApi.RequestTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Request

  defmodule DummyEndpoint do
    def endpoint, do: "/dummy"
  end

  defmodule DummyEndpointWithQuery do
    def endpoint, do: "/dummy?foo=bar"
  end

  test "do_request returns Mint.TransportError reason" do
    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn _req, _finch, _opts ->
      {:error, %Mint.TransportError{reason: :econnrefused}}
    end)

    assert {:error, :econnrefused} =
             Request.do_request(:get, DummyEndpoint, [])
  end

  test "do_request returns Mint.HTTPError reason" do
    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn _req, _finch, _opts ->
      {:error, %Mint.HTTPError{reason: :protocol_error}}
    end)

    assert {:error, :protocol_error} =
             Request.do_request(:get, DummyEndpoint, [])
  end

  test "do_request returns Finch.Error reason" do
    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn _req, _finch, _opts ->
      {:error, %Finch.Error{reason: :timeout}}
    end)

    assert {:error, :timeout} =
             Request.do_request(:get, DummyEndpoint, [])
  end

  test "do_request wraps {data, status} error tuple" do
    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn _req, _finch, _opts ->
      {:error, %{"error" => "bad request"}, 400}
    end)

    assert {:error, {%{"error" => "bad request"}, 400}} =
             Request.do_request(:get, DummyEndpoint, [])
  end

  test "do_request returns other error as-is" do
    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn _req, _finch, _opts ->
      {:error, :weird_error}
    end)

    assert {:error, :weird_error} =
             Request.do_request(:get, DummyEndpoint, [])
  end

  test "do_request merges query params when URL already has query" do
    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch, _opts ->
      assert String.ends_with?(req.path, "/dummy")

      assert_get_params(req, foo: "bar", a: 1)

      {:error, %Finch.Error{reason: :timeout}}
    end)

    assert {:error, :timeout} =
             Request.do_request(:get, DummyEndpointWithQuery, query_params: [a: 1])
  end

  test "maybe_add_json_content_type does not add header if content-type already present (case-insensitive)" do
    headers = [
      {"Content-Type", "application/json"},
      {"accept", "application/json"}
    ]

    body = "{}"

    result = Request.maybe_add_json_content_type(headers, body)

    assert result == headers
  end

  test "maybe_add_json_content_type adds content-type when body present and header missing" do
    headers = [
      {"accept", "application/json"}
    ]

    body = ~s({"foo":"bar"})

    result = Request.maybe_add_json_content_type(headers, body)

    assert [{"content-type", "application/json"} | headers] == result
  end

  test "maybe_add_json_content_type keeps headers when body is empty string" do
    headers = [
      {"accept", "application/json"}
    ]

    body = ""

    result = Request.maybe_add_json_content_type(headers, body)

    assert result == headers
  end

  test "maybe_add_json_content_type keeps headers when body is non-binary" do
    headers = [
      {"accept", "application/json"}
    ]

    body = nil

    result = Request.maybe_add_json_content_type(headers, body)

    assert result == headers
  end
end
