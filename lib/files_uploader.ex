# Application entry point
defmodule FilesUploader do
    use Application
    require Logger

    def start(_type, _args) do
        Logger.info("FilesUploader started...", [])
        port = Application.get_env(:files_uploader, :port)
        children = [
            Plug.Adapters.Cowboy.child_spec(:http, Router, [], port: port),
            Zip
        ]
        Supervisor.start_link(children, [strategy: :one_for_one, name: FilesUploader.Supervisor])
    end
end
