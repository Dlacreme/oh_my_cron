defmodule OMC.Tasks.Agent do
  @moduledoc """
  Store the tasks
  """
  use Agent

  def start_link([config_pathname]) do
    Agent.start_link(fn -> OMC.Tasks.Parser.parse(config_pathname) end, name: __MODULE__)
  end
end
