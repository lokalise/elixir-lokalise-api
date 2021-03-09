defmodule ElixirLokaliseApi.Files do
  @model ElixirLokaliseApi.Model.File
  @collection ElixirLokaliseApi.Collection.Files
  @endpoint "projects/{!:project_id}/files/{:_postfix}"
  @data_key :files
  @singular_data_key nil
  @parent_key :project_id

  use ElixirLokaliseApi.DynamicResource, import: [:all2]

  def download(project_id, data) do
    make_request(:post,
      data: data,
      url_params: url_params(project_id) ++ [{:_postfix, "download"}],
      type: :raw
    )
  end
end
