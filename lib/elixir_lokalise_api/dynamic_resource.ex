defmodule ElixirLokaliseApi.DynamicResource do
  @moduledoc """
  Dynamically adds API methods to the endpoints.

  Usage example:

      use ElixirLokaliseApi.DynamicResource,
        import: [:find2, :all2, :create2, :delete2, :update3]

  The above code equips the target module with multiple API methods that can be conveniently called:

      {:ok, contributor} = ElixirLokaliseApi.Contributors.find(project_id, contributor_id)
  """

  defmacro __using__(options) do
    # coveralls-ignore-start
    import_functions = options[:import] || []
    # coveralls-ignore-stop

    quote bind_quoted: [import_functions: import_functions] do
      alias ElixirLokaliseApi.Request

      @doc false
      def model, do: @model

      @doc false
      def parent_key, do: @parent_key

      @doc false
      def collection, do: @collection

      @doc false
      def data_key, do: @data_key

      @doc false
      def singular_data_key, do: @singular_data_key

      @doc false
      def endpoint, do: @endpoint

      defp make_params(main, other \\ []),
        do: [url_params: apply(__MODULE__, :url_params, main)] ++ other

      @doc false
      def url_params, do: []
      @doc false
      def url_params(p_id), do: [{parent_key(), p_id}]

      if :item_reader in import_functions do
        @doc false
        def item_key, do: @item_key

        @doc false
        def url_params(p_id, i_id), do: url_params(p_id) ++ [{item_key(), i_id}]
      end

      if :foreign_model in import_functions do
        @doc false
        def foreign_model, do: @foreign_model

        @doc false
        def foreign_data_key, do: @foreign_data_key
      end

      if :subitem_reader in import_functions do
        @doc false
        def subitem_key, do: @subitem_key

        @doc false
        def url_params(p_id, i_id, s_id), do: url_params(p_id, i_id) ++ [{subitem_key(), s_id}]
      end

      if :child_reader in import_functions do
        @doc false
        def child_key, do: @child_key

        @doc false
        def url_params(p_id, i_id, s_id, c_id),
          do: url_params(p_id, i_id, s_id) ++ [{child_key(), c_id}]
      end

      if :find in import_functions do
        @doc """
        Finds an item under the given endpoint.
        """
        def find(parent_id), do: do_get([parent_id])
      end

      if :find2 in import_functions do
        @doc """
        Finds an item under the given endpoint.
        """
        def find(parent_id, item_id, params \\ []),
          do: do_get([parent_id, item_id], query_params: params)
      end

      if :find3 in import_functions do
        @doc """
        Finds an item under the given endpoint.
        """
        def find(parent_id, item_id, subitem_id), do: do_get([parent_id, item_id, subitem_id])
      end

      if :find4 in import_functions do
        @doc """
        Finds an item under the given endpoint.
        """
        def find(parent_id, item_id, subitem_id, child_id, params \\ []),
          do: do_get([parent_id, item_id, subitem_id, child_id], query_params: params)
      end

      if :all in import_functions do
        @doc """
        Finds a collection of items under the given endpoint.
        """
        def all(params \\ []), do: do_get([], query_params: params)
      end

      if :all2 in import_functions do
        @doc """
        Finds a collection of items under the given endpoint.
        """
        def all(parent_id, params \\ []), do: do_get([parent_id], query_params: params)
      end

      if :all3 in import_functions do
        @doc """
        Finds a collection of items under the given endpoint.
        """
        def all(parent_id, item_id, params \\ []),
          do: do_get([parent_id, item_id], query_params: params)
      end

      if :all4 in import_functions do
        @doc """
        Finds a collection of items under the given endpoint.
        """
        def all(parent_id, item_id, subitem_id, params \\ []),
          do: do_get([parent_id, item_id, subitem_id], query_params: params)
      end

      if :create in import_functions do
        @doc """
        Creates an item under the given endpoint.
        """
        def create(data), do: do_create([], data: data)
      end

      if :create2 in import_functions do
        @doc """
        Creates an item under the given endpoint.
        """
        def create(parent_id, data), do: do_create([parent_id], data: data)
      end

      if :create3 in import_functions do
        @doc """
        Creates an item under the given endpoint.
        """
        def create(parent_id, item_id, data), do: do_create([parent_id, item_id], data: data)
      end

      if :update2 in import_functions do
        @doc """
        Updates an item under the given endpoint.
        """
        def update(parent_id, data), do: do_update([parent_id], data: data)
      end

      if :update2_bulk in import_functions do
        @doc """
        Updates multiple items under the given endpoint.
        """
        def update_bulk(parent_id, data), do: do_update([parent_id], data: data)
      end

      if :update3 in import_functions do
        @doc """
        Updates an item under the given endpoint.
        """
        def update(parent_id, item_id, data), do: do_update([parent_id, item_id], data: data)
      end

      if :update4 in import_functions do
        @doc """
        Updates an item under the given endpoint.
        """
        def update(parent_id, item_id, subitem_key, data),
          do: do_update([parent_id, item_id, subitem_key], data: data)
      end

      if :update5 in import_functions do
        @doc """
        Updates an item under the given endpoint.
        """
        def update(parent_id, item_id, subitem_key, child_key, data),
          do: do_update([parent_id, item_id, subitem_key, child_key], data: data)
      end

      if :delete in import_functions do
        @doc """
        Deletes an item under the given endpoint.
        """
        def delete(parent_id), do: do_delete([parent_id])
      end

      if :delete2 in import_functions do
        @doc """
        Deletes an item under the given endpoint.
        """
        def delete(parent_id, item_id), do: do_delete([parent_id, item_id])
      end

      if :delete2_bulk in import_functions do
        @doc """
        Deletes multiple items under the given endpoint.
        """
        def delete_bulk(parent_id, data), do: do_delete([parent_id], data: data)
      end

      if :delete3 in import_functions do
        @doc """
        Deletes an item under the given endpoint.
        """
        def delete(parent_id, item_id, subitem_id),
          do: do_delete([parent_id, item_id, subitem_id])
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
