defmodule ElixirLokaliseApi.DynamicResource do
  defmacro __using__(options) do
    import_functions = options[:import] || []

    quote bind_quoted: [import_functions: import_functions] do
      alias ElixirLokaliseApi.Request

      def model, do: @model

      def parent_key, do: @parent_key

      def collection, do: @collection

      def data_key, do: @data_key

      def singular_data_key, do: @singular_data_key

      def endpoint, do: @endpoint

      if :item_reader in import_functions do
        def item_key, do: @item_key
      end

      if :find in import_functions do
        def find(parent_id), do: Request.get(__MODULE__, [ url_params: [{parent_key(), parent_id}] ])
      end

      if :find2 in import_functions do
        def find(parent_id, item_id), do: Request.get(__MODULE__, [ url_params: [{parent_key(), parent_id}, {item_key(), item_id}] ])
      end

      if :all in import_functions do
        def all(params \\ []), do: Request.get(__MODULE__, [ query_params: params ])
      end

      if :all2 in import_functions do
        def all(parent_id, params \\ []), do: Request.get(__MODULE__, [ url_params: [{parent_key(), parent_id}], query_params: params ])
      end

      if :create in import_functions do
        def create(data), do: Request.post(__MODULE__, [ data: data ])
      end

      if :create2 in import_functions do
        def create(parent_id, data), do: Request.post(__MODULE__, [ url_params: [{parent_key(), parent_id}], data: data ])
      end

      if :update in import_functions do
        def update(parent_id, data), do: Request.put(__MODULE__, [ url_params: [{parent_key(), parent_id}], data: data ])
      end

      if :update3 in import_functions do
        def update(parent_id, item_id, data), do: Request.put(__MODULE__, [ url_params: [{parent_key(), parent_id}, {item_key(), item_id}], data: data ])
      end

      if :delete in import_functions do
        def delete(parent_id), do: Request.delete(__MODULE__, [ url_params: [{parent_key(), parent_id}], type: :raw ])
      end

      if :delete2 in import_functions do
        def delete(parent_id, item_id), do: Request.delete(__MODULE__, url_params: [{parent_key(), parent_id}, {item_key(), item_id}], type: :raw)
      end

      # TODO: research further
      def sample(%collection{project_id: project_id}) do
        project_id |> IO.inspect
      end
    end
  end
end
