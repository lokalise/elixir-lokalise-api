defmodule ElixirLokaliseApi.TranslationProviders do
  @model ElixirLokaliseApi.Model.TranslationProvider
  @collection ElixirLokaliseApi.Collection.TranslationProviders
  @endpoint "teams/{!:team_id}/translation_providers/{:translation_provider_id}"
  @data_key :translation_providers
  @singular_data_key nil
  @parent_key :team_id
  @item_key :translation_provider_id

  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :find2, :all2]
end
