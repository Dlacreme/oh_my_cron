defmodule OMC.Tasks.Parser do
  @moduledoc """
  Parse the TOML config file
  """

  defmodule __MODULE__.Task do
    @moduledoc """
    Define a struct that contains all the properties for a Task
    """
    defstruct name: nil, command: nil, interval_in_ms: nil, params: []
  end

  @doc """
  Start the parsing
  """
  @spec parse(String.t()) :: {:ok, list(any)} | {:error, String.t()}
  def parse(pathname) do
    TomlElixir.parse_file(pathname)
    |> parse_content()
  end

  defp parse_content({:error, error_type}) do
    case error_type do
      :enoent -> write_error("Config file is missing")
      _ -> write_error("Failed to parse config file")
    end

    write_error("Program exits.")
    exit(:shutdown)
  end

  defp parse_content({:ok, %{"task" => tasks}}) do
    parse_tasks(tasks, [])
  end

  defp parse_tasks([], parsed_tasks), do: parsed_tasks

  defp parse_tasks([task | tail], parsed_tasks),
    do: parse_tasks(tail, [parse_task(task) | parsed_tasks])

  defp parse_task(%{
         "name" => name,
         "command" => command,
         "params" => params,
         "interval" => interval
       }),
       do: %__MODULE__.Task{
         name: name,
         command: command,
         params: params,
         interval_in_ms: interval_to_ms(interval)
       }

  defp parse_task(invalid_task) do
    write_error("Invalid command > #{inspect(invalid_task)}")
    exit(:shutdown)
  end

  defp interval_to_ms(%{"second" => second, "minute" => minute, "hour" => hour}),
    do: interval_to_ms(%{"second" => second, "minute" => minute + hour * 60})

  defp interval_to_ms(%{"second" => second, "minute" => minute}),
    do: interval_to_ms(%{"second" => second + minute * 60})

  defp interval_to_ms(%{"second" => second}),
    do: second * 1000

  defp write_error(str), do: IO.write(:standard_error, str)
end
