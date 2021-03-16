defmodule ElixirLokaliseApi.Files do
  @model ElixirLokaliseApi.Model.File
  @collection ElixirLokaliseApi.Collection.Files
  @endpoint "projects/{!:project_id}/files/{:_postfix}"
  @data_key :files
  @singular_data_key nil
  @parent_key :project_id
  @foreign_model ElixirLokaliseApi.Model.QueuedProcess
  @foreign_data_key :process

  use ElixirLokaliseApi.DynamicResource, import: [:foreign_model, :all2]

  def download(project_id, data) do
    make_request(:post,
      data: data,
      url_params: url_params(project_id) ++ [{:_postfix, "download"}],
      type: :raw
    )
  end

  def upload(project_id, data) do
    make_request(:post,
      data: data,
      url_params: url_params(project_id) ++ [{:_postfix, "upload"}],
      type: :foreign_model
    )
  end
end
