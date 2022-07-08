defmodule DocumentationExtractor do
  @moduledoc """
  Extracts documentation from modules and their functions and callbacks

  ## Usecase example
  ```elixir
  defmodule A do
    @doc "execs"
    def exec, do: :a
  end

  defmodule B do
    @doc DocumentationExtractor.get_function_docs(A, :exec)
    def exec, do: :b
  end
  ```

  """

  @default_lang nil

  @doc """
  Extracts documentation from a function on a module

  ## Examples

  ```elixir
  iex> DocumentationExtractor.get_module_docs(ExampleModule)
  "A example module\\n"
  ```
  """
  @spec get_function_docs(
          module(),
          atom(),
          nil | :function | :callback,
          nil | integer(),
          nil | binary()
        ) ::
          binary()
  def get_function_docs(
        module,
        function_name,
        kind \\ nil,
        arity \\ nil,
        doc_lang \\ @default_lang
      ) do
    with {:ok, _module_doc, docs} <- get_raw_docs(module) do
      docs
      |> Enum.find(&match_doc_entry(&1, {kind, function_name, arity}))
      |> case do
        {{_kind, _name, _arity}, _anno, _signature, doc, _metadata} ->
          get_doc_with_lang(doc, doc_lang)

        nil ->
          ""
      end
    end
  end

  @doc """
  Extracts documentation from a module

  ## Examples

  ```elixir
  iex> DocumentationExtractor.get_module_docs(ExampleModule)
  "A example module\\n"
  ```
  """
  @spec get_module_docs(module(), nil | binary()) :: binary()
  def get_module_docs(module, doc_lang \\ @default_lang) do
    with {:ok, module_doc, _docs} <- get_raw_docs(module) do
      get_doc_with_lang(module_doc, doc_lang)
    end
  end

  defp match_doc_entry(doc_entry, match = {kind, name, arity}) do
    {entry_type = {_kind, _name, _arity}, _anno, _signature, _doc, _metadata} = doc_entry

    case {kind, arity} do
      {nil, nil} ->
        match?({_kind, ^name, _arity}, entry_type)

      {kind, nil} ->
        match?({^kind, ^name, _arity}, entry_type)

      {nil, arity} ->
        match?({_kind, ^name, ^arity}, entry_type)

      {_kind, _arity} ->
        entry_type == match
    end
  end

  defp get_raw_docs(module) do
    with {:docs_v1, _anno, :elixir, _format, module_doc, _metadata, docs} <-
           Code.fetch_docs(module) do
      {:ok, module_doc, docs}
    end
  end

  defp get_doc_with_lang(docs_map, nil) when is_map(docs_map) do
    docs_map
    |> Map.to_list()
    |> List.first()
    |> case do
      {_lang, doc} -> doc
      nil -> ""
    end
  end

  defp get_doc_with_lang(docs_map, lang) when is_map(docs_map) do
    Map.get(docs_map, lang, "")
  end

  defp get_doc_with_lang(_, _), do: ""
end
