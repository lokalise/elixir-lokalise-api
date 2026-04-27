defmodule ElixirLokaliseApi.ProjectLanguages do
  @moduledoc """
  Project languages endpoint.
  """
  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :find2, :all2, :create2, :delete2, :update3]

  alias ElixirLokaliseApi.Collection.Languages
  alias ElixirLokaliseApi.Model.Language

  @model Language
  @collection Languages
  @endpoint "projects/{!:project_id}/languages/{:lang_id}"
  @data_key :languages
  @singular_data_key :language
  @parent_key :project_id
  @item_key :lang_id
end
