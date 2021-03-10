defmodule ElixirLokaliseApi.SystemLanguages do
  @model ElixirLokaliseApi.Model.Language
  @collection ElixirLokaliseApi.Collection.Languages
  @endpoint "system/languages"
  @data_key :languages
  @singular_data_key nil
  @parent_key nil

  use ElixirLokaliseApi.DynamicResource, import: [:all]
end
