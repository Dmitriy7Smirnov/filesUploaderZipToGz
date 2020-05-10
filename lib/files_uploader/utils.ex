# Auxiliary functions
defmodule Utils do
    def get_header(header_name, headers) do
        [head | tail] = headers
        case head do
            {^header_name, header_value} -> {:ok, header_value}
            {_another_name, _} -> get_header(header_name, tail)
            _ -> {:error, "header not found"}
        end
    end

    def get_file_path(header_value) do
        result_list = Regex.run(~r/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/, header_value)
        [_, path, _] = result_list
        clear_path = Regex.replace(~r/['"]/, path, "")
        IO.inspect(result_list, label: "regular expression")
        IO.inspect(clear_path, label: "clear path")
        clear_path
    end

    def get_file_name(header_value) do
        result_list = Regex.run(~r/name[^;=\n]*=((['"]).*?\2|[^;\n]*)/, header_value)
        [_, path, _] = result_list
        clear_name = Regex.replace(~r/['"]/, path, "")
        IO.inspect(result_list, label: "regular expression")
        IO.inspect(clear_name, label: "clear name")
        clear_name
    end

    def make_gz(filestream, filepath) do
        #filepath
        #|> File.stream!
        filestream
        |> StreamGzip.gzip
        |> Stream.into(File.stream! (filepath <> ".gz"))
        |> Stream.run
    end

    def zip_to_gz(file_name) do
        IO.inspect(file_name, label: "input_file_name")

        # Unzip.LocalFile implements Unzip.FileAccess
        zip_file = Unzip.LocalFile.open(file_name)

        # `new` reads list of files by reading central directory found at the end of the zip
       {:ok, unzip} = Unzip.new(zip_file)

        # presents already read files metadata
        file_entries = Unzip.list_entries(unzip)
        IO.inspect(file_entries, label: "file_entries")
        List.foldl(file_entries, 0, fn entry, _acc -> IO.inspect(entry.file_name, label: "file_name"); 0 end)

        path_to_zip = List.foldr(
            file_entries,
            "",
            fn entry, acc ->
                case entry.compressed_size do
                    0 ->
                        IO.inspect(entry.file_name, label: "compressed_size 0")
                        create_dir(entry.file_name, file_name);
                    _ -> acc
                end
            end)

        List.foldr(
            file_entries,
            "",
            fn entry, _acc ->
                case entry.compressed_size do
                    0 -> "";
                    _ ->
                        make_gz(Unzip.file_stream!(unzip, entry.file_name), path_to_zip <> entry.file_name)
                end
            end)

    end

    def create_dir(zip_name, file_name) do
        IO.inspect(zip_name, label: "zip_name")

        zip_name1 = Regex.replace(~r/\/$/, zip_name, "")

        IO.inspect(zip_name1, label: "zip_name1")

        path_to_zip = Regex.replace(~r/[a-zA-Z0-9]{1,}.zip$/, file_name, "")
        IO.inspect(path_to_zip, label: "path_to_zip")

        File.mkdir_p!(path_to_zip <> zip_name1)
        path_to_zip
    end

end
