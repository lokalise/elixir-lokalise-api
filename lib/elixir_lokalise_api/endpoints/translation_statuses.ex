defmodule ElixirLokaliseApi.TranslationStatuses do
  @model ElixirLokaliseApi.Model.TranslationStatus
  @collection ElixirLokaliseApi.Collection.TranslationStatuses
  @endpoint "projects/{!:project_id}/custom_translation_statuses/{:status_id}/{:_postfix}"
  @data_key :custom_translation_statuses
  @singular_data_key :custom_translation_status
  @parent_key :project_id
  @item_key :status_id

  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :find2, :all2, :create2, :update3, :delete2]

  def available_colors(project_id) do
    make_request(:get,
      data: nil,
      url_params: url_params(project_id) ++ [{:_postfix, "colors"}],
      type: :raw
    )
  end
end
