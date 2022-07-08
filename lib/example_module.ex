defmodule ExampleModule do
  @moduledoc """
  A example module
  """

  @doc "Greets given name"
  def greet(name) do
    "Hello #{name}!"
  end

  @doc false
  def bye(name) do
    "Bye #{name}!"
  end
end
