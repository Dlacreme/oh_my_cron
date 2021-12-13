defmodule OMC.Runner.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(opts \\ []) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def run(%OMC.Tasks.Parser.Task{} = task) do
    IO.puts("RUN TASK > #{inspect(task)}")
  end
end
