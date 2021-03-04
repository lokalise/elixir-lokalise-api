defmodule ElixirLokaliseApi.DynamicResource do
  defmacro __using__(options) do
    import_functions = options[:import] || []

    quote bind_quoted: [import_functions: import_functions] do
      alias ElixirLokaliseApi.Request

      def model, do: @model

      def parent_key, do: @parent_key

      def collection, do: @collection

      def data_key, do: @data_key

      def endpoint, do: @endpoint

      if :find in import_functions do
        def find(id), do: Request.get(__MODULE__, [ url_params: [{parent_key(), id}] ])
      end

      if :all in import_functions do
        def all(params \\ []), do: Request.get(__MODULE__, [ query_params: params ])
      end

      if :create in import_functions do
        def create(data), do: Request.post(__MODULE__, [ data: data ])
      end

      if :update in import_functions do
        def update(id, data), do: Request.put(__MODULE__, [ url_params: [{parent_key(), id}], data: data ])
      end

      if :delete in import_functions do
        def delete(id), do: Request.delete(__MODULE__, [ url_params: [{parent_key(), id}], type: :raw ])
      end

      # TODO: research further
      def sample(%collection{project_id: project_id}) do
        project_id |> IO.inspect
      end
    end
  end
end
