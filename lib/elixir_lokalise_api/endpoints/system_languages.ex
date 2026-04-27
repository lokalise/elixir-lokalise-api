defmodule ElixirLokaliseApi.SystemLanguages do
  @moduledoc """
  System languages endpoint.
  """
  use ElixirLokaliseApi.DynamicResource, import: [:all]

  alias ElixirLokaliseApi.Collection.Languages
  alias ElixirLokaliseApi.Model.Language

  @model Language
  @collection Languages
  @endpoint "system/languages"
  @data_key :languages
  @singular_data_key nil
  @parent_key nil
end
