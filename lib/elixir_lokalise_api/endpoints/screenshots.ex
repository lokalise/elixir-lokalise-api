defmodule ElixirLokaliseApi.Screenshots do
  @moduledoc """
  Screenshots endpoint.
  """
  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :all2, :find2, :create2, :update3, :delete2]

  alias ElixirLokaliseApi.Collection.Screenshots
  alias ElixirLokaliseApi.Model.Screenshot

  @model Screenshot
  @collection Screenshots
  @endpoint "projects/{!:project_id}/screenshots/{:screenshot_id}"
  @data_key :screenshots
  @singular_data_key :screenshot
  @parent_key :project_id
  @item_key :screenshot_id
end
