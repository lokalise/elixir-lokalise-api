defmodule ElixirLokaliseApi.Parser do
  alias ElixirLokaliseApi.Endpoint.Project

  def parse(response) do
    handle_errors(response, fn body ->
      struct(Project, List.first(Jason.decode!(body, keys: :atoms)[:projects]))
    end)
  end

  defp handle_errors(response, fun) do
    case response do
      %{body: body, status_code: status} when status in [200, 201] ->
        {:ok, fun.(body)}

      %{body: _, status_code: status} when status in [202, 204] ->
        :ok

      %{body: body, status_code: status} ->
        {:error, Jason.decode!(body), status}
    end
  end
end
