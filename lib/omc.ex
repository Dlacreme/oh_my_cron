defmodule OMC do
  @moduledoc """
  Documentation for `OMC`.
  """

  @doc """
  """
  def start do
    OMC.Tasks.get() |> Enum.each(&boot_task!(&1))
  end

  defp boot_task!(task) do
    IO.puts("BOOT > #{inspect(task)}")
  end
end
