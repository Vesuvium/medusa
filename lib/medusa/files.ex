defmodule Medusa.Files do
  @moduledoc """
  Files utilities
  """

  @doc """
  Search files with a given extension, including nested directories.
  """
  def search(path, extension) do
    expand(File.ls(path), path, extension)
  end

  defp expand({:ok, files}, path, extension) do
    files
    |> Enum.flat_map(&search("#{path}/#{&1}", extension))
  end

  defp expand({:error, _}, path, extension) do
    if String.ends_with?(path, extension) do
      [path]
    else
      []
    end
  end

  def write(path, content) do
    shards = String.split(path, "/")

    Enum.take(shards, Enum.count(shards) - 1)
    |> Enum.join("/")
    |> File.mkdir_p!()

    File.write(path, content)
  end
end
