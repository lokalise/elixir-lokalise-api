defmodule ElixirLokaliseApi.Processor do
  @pagination_headers %{
    "x-pagination-total-count" => :total_count,
    "x-pagination-page-count" => :page_count,
    "x-pagination-limit" => :per_page_limit,
    "x-pagination-page" => :current_page
  }

  def parse(response, module, :raw), do: do_parse(response, module, :raw)
  def parse(response, module, _), do: do_parse(response, module, nil)

  def encode(nil), do: ""
  def encode(data), do: Jason.encode!(data)

  defp do_parse(response, module, type) do
    data_key = module.data_key
    singular_data_key = module.singular_data_key
    json = response.body |> Jason.decode!(keys: :atoms)
    status = response.status_code

    case json do
      raw_data when type == :raw and status < 400 ->
        {:ok, raw_data}

      %{^data_key => items_data}
      when (is_list(items_data) or is_map(items_data)) and status < 400 ->
        {:ok, create_struct(:collection, module, items_data, response.headers, json)}

      %{^singular_data_key => item_data}
      when (is_list(item_data) or is_map(item_data)) and status < 400 ->
        {:ok, create_struct(:model, module, item_data)}

      item_data when status < 400 ->
        {:ok, create_struct(:model, module, item_data)}

      raw_data ->
        {:error, raw_data, status}
    end
  end

  defp create_struct(:model, module, item_data), do: struct(module.model, item_data)

  defp create_struct(:collection, module, items_data, resp_headers, raw_json) do
    struct_data =
      struct_for_items(module, items_data)
      |> add_data_by_key(module.parent_key, raw_json)
      |> add_data_by_key(:branch, raw_json)
      |> add_data_by_key(:user_id, raw_json)
      |> add_data_by_key(:errors, raw_json)
      |> pagination_for(resp_headers)

    module.collection |> struct(struct_data)
  end

  defp struct_for_items(module, raw_data) do
    Enum.reduce(Enum.reverse(raw_data), %{items: []}, fn item, acc ->
      struct_item = struct(module.model, item)

      %{acc | items: [struct_item | acc.items]}
    end)
  end

  def pagination_for(struct_data, resp_headers) do
    Enum.reduce(@pagination_headers, struct_data, fn {raw_header, formatted_header}, acc ->
      case get_header(resp_headers, raw_header) do
        [] ->
          acc

        [list | _] ->
          {header_value, _} = list |> elem(1) |> Integer.parse()
          acc |> Map.put(formatted_header, header_value)
      end
    end)
  end

  defp get_header(headers, key) do
    headers
    |> Enum.filter(fn {k, _} -> String.downcase(k) == to_string(key) end)
  end

  defp add_data_by_key(struct_data, key, raw_json) do
    case raw_json[key] do
      nil ->
        struct_data

      value ->
        struct_data |> Map.put(key, value)
    end
  end
end
