defmodule OMC.Tasks do
  @moduledoc """
  Parse, validate & store all the tasks.
  """

  @doc """
  Retrive the list of tasks
  """
  def get do
    Agent.get(__MODULE__.Agent, & &1)
  end
end
