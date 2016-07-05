defmodule StackServer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(StackServer.Server, [["cat", 'cat', 347]])
    ]

    opts = [strategy: :one_for_one, name: StackServer.Supervisor]
    { :ok, _pid } = Supervisor.start_link(children, opts)
  end
end
