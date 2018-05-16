defmodule Mix.Tasks.Bird.Gen.Docs do
  @moduledoc """
  Generates HTML API Docs from api.apib using aglio.

  This task uses [Aglio](https://github.com/danielgtaylor/aglio) to render the
  file. To install, run `npm install aglio -g`.
  """
  use Mix.Task

  alias Mix.Project

  @doc false
  def run(_args) do
    if System.find_executable("aglio") == nil do
      raise "Install Aglio to convert Blueprint API to HTML: " <>
              "\"npm install aglio -g\""
    end

    docs_path = Application.get_env(:blue_bird, :docs_path, "docs")
    docs_theme = Application.get_env(:blue_bird, :docs_theme, "triple")

    path =
      Project.build_path()
      |> String.split("_build")
      |> Enum.at(0)
      |> Path.join(docs_path)

    System.cmd("aglio", [
      "--theme-template",
      docs_theme,
      "--theme-condense-nav",
      "false",
      "-i",
      Path.join(path, "api.apib"),
      "-o",
      Path.join(path, "index.html")
    ])
  end
end
