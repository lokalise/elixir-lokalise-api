defmodule ElixirLokaliseApi.Parser do
  def parse(response, module) do
    do_process(response, module)
  end

  defp do_process(response, module) do
    data_key = module.data_key
    json = Jason.decode!(response.body, keys: :atoms)
    status = response.status_code

    case json do
      %{^data_key => data} when status < 400 ->
        {:ok, create_struct(module.collection, %{data_key => data})}

      data when status < 400 ->
        {:ok, create_struct(module.model, data)}

      data ->
        {:error, data, status}
    end
  end

  defp create_struct(type, data) do
    struct(type, data)
  end
end
