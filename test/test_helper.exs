ExUnit.start()

Mox.defmock(ElixirLokaliseApi.HTTPClientMock,
  for: ElixirLokaliseApi.HTTPClient
)

defmodule ElixirLokaliseApi.TestHTTP do
  require ExUnit.Assertions
  import ExUnit.Assertions

  def ok(body, headers \\ []) do
    {:ok,
     %Finch.Response{
       status: 200,
       headers: headers,
       body: Jason.encode!(body)
     }}
  end

  def err(status, body, headers \\ []) do
    {:ok,
     %Finch.Response{
       status: status,
       headers: headers,
       body: Jason.encode!(body)
     }}
  end

  def assert_json_body(req, expected) do
    case req.body do
      "" ->
        assert expected == ""
        assert req.body == ""

      body ->
        decoded = Jason.decode!(body, keys: :atoms)
        assert decoded == expected
    end
  end

  def assert_path_method(req, path, method \\ "GET") do
    assert(req.method == method)
    assert(req.host == "api.lokalise.com")
    assert(req.path == path)
  end

  def assert_get_params(req, expected_params) do
    decoded = URI.decode_query(req.query || "")

    expected =
      expected_params
      |> Enum.into(%{}, fn {k, v} ->
        {to_string(k), to_string(v)}
      end)

    expected
    |> Enum.each(fn {key, value} ->
      assert(Map.get(decoded, key) == value)
    end)

    assert(
      Map.keys(decoded) |> Enum.sort() ==
        expected
        |> Map.keys()
        |> Enum.map(&to_string/1)
        |> Enum.sort()
    )
  end
end

defmodule ElixirLokaliseApi.Case do
  use ExUnit.CaseTemplate

  using opts do
    quote do
      use ExUnit.Case, unquote(opts)

      import Mox
      import ElixirLokaliseApi.TestHTTP

      setup :set_mox_from_context
      setup :verify_on_exit!
    end
  end
end
