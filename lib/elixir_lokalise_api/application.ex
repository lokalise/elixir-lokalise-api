defmodule ElixirLokaliseApi.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Finch, name: ElixirLokaliseApi.Finch}
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: ElixirLokaliseApi.Supervisor
    )
  end
end
