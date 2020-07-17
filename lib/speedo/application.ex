defmodule Speedo.Application do
  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Speedo.Supervisor]

    children = [
      {Registry, name: Speedo.Registry, keys: :duplicate}
    ]

    Supervisor.start_link(children, opts)
  end
end
