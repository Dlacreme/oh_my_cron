defmodule OMC.Application do
  @moduledoc """
  Root supervisor of OMC
  """
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Loads and store the tasks
      OMC.Tasks.Agent.child_spec([Application.fetch_env!(:oh_my_cron, :tasks_pathname)])
    ]

    opts = [strategy: :one_for_one, name: OMC.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
