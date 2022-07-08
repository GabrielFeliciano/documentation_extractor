defmodule DocumentationExtractorTest do
  @moduledoc """
  Testing main module
  """

  use ExUnit.Case
  doctest DocumentationExtractor

  test "Extracts the documentation from example module" do
    assert DocumentationExtractor.get_function_docs(ExampleModule, :greet) ==
             "Greets given name"

    assert DocumentationExtractor.get_function_docs(ExampleModule, :bye) ==
             ""

    assert DocumentationExtractor.get_module_docs(ExampleModule) == "A example module\n"
  end

  test "Extracts the documentation from package module" do
    assert DocumentationExtractor.get_function_docs(DocumentationExtractor, :get_function_docs) ==
             "Extracts documentation from a function on a module\n\n## Examples\n\n```elixir\niex> DocumentationExtractor.get_module_docs(ExampleModule)\n\"A example module\\n\"\n```\n"

    assert DocumentationExtractor.get_module_docs(DocumentationExtractor) ==
             "Extracts documentation from modules and their functions and callbacks\n\n## Usecase example\n```elixir\ndefmodule A do\n  @doc \"execs\"\n  def exec, do: :a\nend\n\ndefmodule B do\n  @doc DocumentationExtractor.get_function_docs(A, :exec)\n  def exec, do: :b\nend\n```\n\n"
  end
end
