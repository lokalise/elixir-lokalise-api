defmodule ElixirLokaliseApi.DynamicResource do
  defmacro __using__(options) do
    import_functions = options[:import] || []

    quote bind_quoted: [import_functions: import_functions] do
      alias ElixirLokaliseApi.Request

      if :get in import_functions do
        def get(), do: Request.get() #__MODULE__, sid, options)
      end
    end
  end
end
