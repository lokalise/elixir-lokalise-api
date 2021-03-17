defmodule ElixirLokaliseApi.Files do
  @moduledoc """
  Files endpoint.
  """

  @model ElixirLokaliseApi.Model.File
  @collection ElixirLokaliseApi.Collection.Files
  @endpoint "projects/{!:project_id}/files/{:_postfix}"
  @data_key :files
  @singular_data_key nil
  @parent_key :project_id
  @foreign_model ElixirLokaliseApi.Model.QueuedProcess
  @foreign_data_key :process

  use ElixirLokaliseApi.DynamicResource, import: [:foreign_model, :all2]

  @doc """
  Downloads a translation bundle from the project.
  """
  def download(project_id, data) do
    make_request(:post,
      data: data,
      url_params: url_params(project_id) ++ [{:_postfix, "download"}],
      type: :raw
    )
  end

  @doc """
  Uploads base64-encoded translations to the project.
  """
  def upload(project_id, data) do
    make_request(:post,
      data: data,
      url_params: url_params(project_id) ++ [{:_postfix, "upload"}],
      type: :foreign_model
    )
  end
end
