defmodule ElixirLokaliseApi.DynamicResource do
  defmacro __using__(options) do
    import_functions = options[:import] || []

    quote bind_quoted: [import_functions: import_functions] do
      alias ElixirLokaliseApi.Request

      if :find in import_functions do
        def find(id), do: Request.get(__MODULE__, id)
      end

      if :all in import_functions do
        def all, do: Request.get(__MODULE__)
      end
    end
  end
end
