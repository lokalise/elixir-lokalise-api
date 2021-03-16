defmodule ElixirLokaliseApi.Screenshots do
  @model ElixirLokaliseApi.Model.Screenshot
  @collection ElixirLokaliseApi.Collection.Screenshots
  @endpoint "projects/{!:project_id}/screenshots/{:screenshot_id}"
  @data_key :screenshots
  @singular_data_key :screenshot
  @parent_key :project_id
  @item_key :screenshot_id

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :all2, :find2, :create2, :update3, :delete2]
end
