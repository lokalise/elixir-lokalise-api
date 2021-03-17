defmodule ElixirLokaliseApi.Translations do
  @model ElixirLokaliseApi.Model.Translation
  @collection ElixirLokaliseApi.Collection.Translations
  @endpoint "projects/{!:project_id}/translations/{:translation_id}"
  @data_key :translations
  @singular_data_key :translation
  @parent_key :project_id
  @item_key :translation_id

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :all2, :find2, :update3]
end
