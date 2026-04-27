defmodule ElixirLokaliseApi.TranslationProviders do
  @moduledoc """
  Translation providers endpoint.
  """
  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :find2, :all2]

  alias ElixirLokaliseApi.Collection.TranslationProviders
  alias ElixirLokaliseApi.Model.TranslationProvider

  @model TranslationProvider
  @collection TranslationProviders
  @endpoint "teams/{!:team_id}/translation_providers/{:translation_provider_id}"
  @data_key :translation_providers
  @singular_data_key nil
  @parent_key :team_id
  @item_key :translation_provider_id
end
