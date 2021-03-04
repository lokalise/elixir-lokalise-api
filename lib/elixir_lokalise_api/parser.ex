defmodule ElixirLokaliseApi.Parser do
  def parse(response, module), do: do_process(response, module)

  defp do_process(response, module) do
    data_key = module.data_key
    json = response.body |> Jason.decode!(keys: :atoms)
    status = response.status_code

    case json do
      %{^data_key => data} when status < 400 ->
        {:ok, create_struct(:collection, module, data)}

      data when status < 400 ->
        {:ok, create_struct(:model, module, data)}

      data ->
        {:error, data, status}
    end
  end

  defp create_struct(:model, module, data), do: struct(module.model, data)

  defp create_struct(:collection, module, data) do
    struct_data = Enum.reduce Enum.reverse(data), %{items: []}, fn item, acc ->
      struct_item = struct module.model, item

      %{acc | items:
        [ struct_item | acc.items ]
      }
    end

    struct module.collection, struct_data
  end
end
