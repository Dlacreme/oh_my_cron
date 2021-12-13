defmodule OMC.Runner do
  use GenServer

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @impl true
  def init(_opts) do
    # small trick to wait for the Agent to load everything
    :timer.send_after(1000, :start)
    {:ok, nil}
  end

  @impl true
  def handle_info(:start, _params) do
    with tasks <- OMC.Tasks.get(),
         :ok <- Enum.each(tasks, &setup_task(&1)) do
      {:noreply, tasks}
    else
      _err -> :error
    end
  end

  @impl true
  def handle_info(
        {:execute, %OMC.Tasks.Parser.Task{name: name, command: command, params: params}},
        tasks
      ) do
    {res, _} = System.cmd(command, params)
    IO.puts("Task #{name} executed successfully:\n#{inspect(res)}\n")
    {:noreply, tasks}
  end

  defp setup_task(%OMC.Tasks.Parser.Task{interval_in_ms: interval_in_ms} = task) do
    :timer.send_interval(interval_in_ms, {:execute, task})
  end
end
