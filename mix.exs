defmodule FilesUploader.Mixfile do
  use Mix.Project

  def project do
    [app: :files_uploader,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :cowboy, :plug],
      mod: {FilesUploader, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.1.2"},
      {:plug_cowboy, "~> 1.0"},
      {:plug, "~> 1.10.0"},
      {:stream_gzip, "~> 0.4"},
      {:unzip, "~> 0.6.0"}
    ]
  end
end
