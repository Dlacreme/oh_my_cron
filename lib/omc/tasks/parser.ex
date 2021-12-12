defmodule OMC.Tasks.Parser do
  @moduledoc """
  Parse the TOML config file
  """

  defmodule __MODULE__.Task do
    defstruct name: nil, command: nil, interval: nil
  end

  @spec parse(String.t()) :: {:ok, list(any)} | {:error, String.t()}
  def parse(filename) do
    TomlElixir.parse_file(filename)
    |> parse_content()
    |> tap(&IO.puts("Parsed tasks > #{inspect(&1)}"))
  end

  defp parse_content({:ok, %{"task" => tasks}}) do
    parse_tasks(tasks, [])
  end

  defp parse_content({:error, error_type}) do
    case error_type do
      :enoent -> write_error("Config file is missing")
      _ -> write_error("Failed to parse config file")
    end

    write_error("Program exits.")
    exit(:shutdown)
  end

  defp parse_tasks([], parsed_tasks), do: parsed_tasks

  defp parse_tasks([task | tail], parsed_tasks),
    do: parse_tasks(tail, [parse_task(task) | parsed_tasks])

  defp parse_task(%{"name" => name, "command" => command, "interval" => interval}),
    do: %__MODULE__.Task{
      name: name,
      command: command,
      interval: interval
    }

  defp parse_task(invalid_task) do
    write_error("Invalid command > #{inspect(invalid_task)}")
    exit(:shutdown)
  end

  defp write_error(str), do: IO.write(:standard_error, str)
end
