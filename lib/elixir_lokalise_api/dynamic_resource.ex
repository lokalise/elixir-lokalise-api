defmodule ElixirLokaliseApi.DynamicResource do
  defmacro __using__(options) do
    # coveralls-ignore-start
    import_functions = options[:import] || []
    # coveralls-ignore-stop

    quote bind_quoted: [import_functions: import_functions] do
      alias ElixirLokaliseApi.Request

      def model, do: @model

      def parent_key, do: @parent_key

      def collection, do: @collection

      def data_key, do: @data_key

      def singular_data_key, do: @singular_data_key

      def endpoint, do: @endpoint

      defp make_params(main, other \\ []),
        do: [url_params: apply(__MODULE__, :url_params, main)] ++ other

      def url_params, do: []
      def url_params(p_id), do: [{parent_key(), p_id}]

      if :item_reader in import_functions do
        def item_key, do: @item_key

        def url_params(p_id, i_id), do: url_params(p_id) ++ [{item_key(), i_id}]
      end

      if :foreign_model in import_functions do
        def foreign_model, do: @foreign_model

        def foreign_data_key, do: @foreign_data_key
      end

      if :subitem_reader in import_functions do
        def subitem_key, do: @subitem_key

        def url_params(p_id, i_id, s_id), do: url_params(p_id, i_id) ++ [{subitem_key(), s_id}]
      end

      if :find in import_functions do
        def find(parent_id), do: do_get([parent_id])
      end

      if :find2 in import_functions do
        def find(parent_id, item_id, params \\ []),
          do: do_get([parent_id, item_id], query_params: params)
      end

      if :find3 in import_functions do
        def find(parent_id, item_id, subitem_id), do: do_get([parent_id, item_id, subitem_id])
      end

      if :all in import_functions do
        def all(params \\ []), do: do_get([], query_params: params)
      end

      if :all2 in import_functions do
        def all(parent_id, params \\ []), do: do_get([parent_id], query_params: params)
      end

      if :all3 in import_functions do
        def all(parent_id, item_id, params \\ []),
          do: do_get([parent_id, item_id], query_params: params)
      end

      if :create in import_functions do
        def create(data), do: do_create([], data: data)
      end

      if :create2 in import_functions do
        def create(parent_id, data), do: do_create([parent_id], data: data)
      end

      if :create3 in import_functions do
        def create(parent_id, item_id, data), do: do_create([parent_id, item_id], data: data)
      end

      if :update2 in import_functions do
        def update(parent_id, data), do: do_update([parent_id], data: data)
      end

      if :update2_bulk in import_functions do
        def update_bulk(parent_id, data), do: do_update([parent_id], data: data)
      end

      if :update3 in import_functions do
        def update(parent_id, item_id, data), do: do_update([parent_id, item_id], data: data)
      end

      if :delete in import_functions do
        def delete(parent_id), do: do_delete([parent_id])
      end

      if :delete2 in import_functions do
        def delete(parent_id, item_id), do: do_delete([parent_id, item_id])
      end

      if :delete2_bulk in import_functions do
        def delete_bulk(parent_id, data), do: do_delete([parent_id], data: data)
      end

      if :delete3 in import_functions do
        def delete(parent_id, item_id, subitem_id),
          do: do_delete([parent_id, item_id, subitem_id])
      end

      # TODO: research further
      def sample(%collection{project_id: project_id}) do
        project_id |> IO.inspect()
      end

      defp do_get(params, other_params \\ []), do: make_request(:get, params, other_params)

      defp do_create(params, other_params \\ []), do: make_request(:post, params, other_params)

      defp do_update(params, other_params \\ []), do: make_request(:put, params, other_params)

      defp do_delete(params, other_params \\ []),
        do: make_request(:delete, params, other_params ++ [type: :raw])

      defp make_request(verb, params), do: Request.do_request(verb, __MODULE__, params)

      defp make_request(verb, params, other_params),
        do: Request.do_request(verb, __MODULE__, make_params(params, other_params))
    end
  end
end
