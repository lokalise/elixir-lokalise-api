defmodule ElixirLokaliseApi.Files do
  @moduledoc """
  Files endpoint.
  """

  @model ElixirLokaliseApi.Model.File
  @collection ElixirLokaliseApi.Collection.Files
  @endpoint "projects/{!:project_id}/files/{:file_id}/{:_postfix}"
  @data_key :files
  @singular_data_key nil
  @parent_key :project_id
  @foreign_model ElixirLokaliseApi.Model.QueuedProcess
  @foreign_data_key :process
  @item_key :file_id

  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :foreign_model, :all2, :delete2]

  @spec download(any, any) :: {:error, atom | binary | {map, integer}} | {:ok, map}
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
  Downloads a translation bundle from the project asynchronously.
  """
  def download_async(project_id, data) do
    make_request(:post,
      data: data,
      url_params: url_params(project_id) ++ [{:_postfix, "async-download"}],
      type: :foreign_model
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
