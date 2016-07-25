defmodule Sqlite.Ecto.Mixfile do
  use Mix.Project

  def project do
    [app: :sqlite_ecto,
     version: "1.3.0",
     name: "Sqlite.Ecto",
     elixir: "~> 1.2",
     deps: deps,

     # testing
     build_per_environment: false,
     test_paths: test_paths(Mix.env),
     aliases: ["test.all": &test_all/1,
               "test.integration": &test_integration/1],
     preferred_cli_env: ["test.all": :test],

     # hex
     description: description,
     package: package,

     # docs
     docs: [main: Sqlite.Ecto]]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:logger, :db_connection, :ecto]]
  end

  # Dependencies
  defp deps do
    [{:earmark, "~> 1.0", only: :dev},
     {:ex_doc, "~> 0.12", only: :dev},
     {:ecto, "~> 2.0"},
     {:poison, "~> 2.0"},
     {:sqlitex, "~> 1.0"},
     # {:connection, "~> 1.0"},
     {:db_connection, "~> 1.0-rc"}]
  end

  defp description, do: "SQLite3 adapter for Ecto"

  defp package do
    [maintainers: ["Jason M Barnes"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/jazzyb/sqlite_ecto"}]
  end

  defp test_paths(:integration), do: ["integration/sqlite"]
  defp test_paths(_), do: ["test"]

  defp test_integration(args) do
    args = if IO.ANSI.enabled?, do: ["--color" | args], else: ["--no-color" | args]
    System.cmd "mix", ["test" | args], into: IO.binstream(:stdio, :line),
                                       env: [{"MIX_ENV", "integration"}]
  end

  defp test_all(args) do
    Mix.Task.run "test", args
    {_, res} = test_integration(args)
    if res != 0, do: exit {:shutdown, 1}
  end
end
