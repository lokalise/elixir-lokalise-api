defmodule ElixirLokaliseApi.Processor do
  @pagination_headers %{
                        "x-pagination-total-count" => :total_count,
                        "x-pagination-page-count" => :page_count,
                        "x-pagination-limit" => :per_page_limit,
                        "x-pagination-page" => :current_page
                      }

  def parse(response, module, :raw), do: do_parse(response, module, :raw)
  def parse(response, module, _), do: do_parse(response, module, nil)

  defp do_parse(response, module, type) do
    do_process(response, module, type)
  end

  def encode(nil), do: ""
  def encode(data), do: Jason.encode!(data)

  defp do_process(response, module, type) do
    data_key = module.data_key
    json = response.body |> Jason.decode!(keys: :atoms)
    status = response.status_code

    case json do
      data when type == :raw and status < 400 ->
        {:ok, data}

      %{^data_key => data} when (is_list(data) or is_map(data)) and status < 400 ->
        {:ok, create_struct(:collection, module, data, response.headers)}

      data when status < 400 ->
        {:ok, create_struct(:model, module, data)}

      data ->
        {:error, data, status}
    end
  end

  defp create_struct(:model, module, data), do: struct(module.model, data)

  defp create_struct(:collection, module, data, resp_headers) do
    struct_data = struct_for_items(module, data)
    |> pagination_for(resp_headers)

    struct module.collection, struct_data
  end

  defp struct_for_items(module, data) do
    Enum.reduce Enum.reverse(data), %{items: []}, fn item, acc ->
      struct_item = struct module.model, item

      %{acc | items:
        [ struct_item | acc.items ]
      }
    end
  end

  def pagination_for(data, resp_headers) do
    Enum.reduce @pagination_headers, data, fn {raw_header, formatted_header}, acc ->
      case get_header(resp_headers, raw_header) do
        [] ->
          acc

        [ list | _ ] ->
          {header_value, _} = list |> elem(1) |> Integer.parse()
          acc |> Map.put(formatted_header, header_value)
      end
    end
  end

  defp get_header(headers, key) do
    headers
    |> Enum.filter(fn {k, _} -> String.downcase(k) == to_string(key) end)
  end
end
