defmodule Parser do
    def read_headers(conn) do
        case Plug.Conn.read_part_headers(conn) do
            {:ok, headers, conn} ->
                IO.puts("I'm in header's case")
                IO.inspect(headers, label: "headers")
                {:ok, header_value} = Utils.get_header("content-disposition", headers)
                IO.inspect(header_value, label: "filename")
                name = Utils.get_file_path(header_value)
                Parser.read_body(conn, name, nil, nil)
            {:done, conn} ->
                conn
        end
    end

    def read_body(conn, file_name, file_handler, z) do
        {file_handler, z} = case file_handler do
            nil ->
                str_arr = String.split(file_name, "/")
                dir_arr = List.delete_at(str_arr, length(str_arr) - 1)
                File.mkdir_p!(List.foldr(dir_arr, "", fn x, acc -> x <> "/" <> acc end))
                # z = :zlib.open()
                # :zlib.deflateInit(z, 1, :deflated, 16 + 15, 8, :default)
                case File.open(file_name, [:write]) do
                    {:ok, file_handler} -> {file_handler, z}
                    {:error, reason} -> {:error, reason}
                end
            file_handler -> {file_handler, z}
        end
        case Plug.Conn.read_part_body(conn, length: 1_000) do
            {:ok, data, conn} ->
                #Utils.make_zip(:binary.bin_to_list(data), file_name)
                # b1 = :zlib.deflate(z, data)
                # b2 = :zlib.deflate(z, "",:finish)
                # :zlib.deflateEnd(z)
                # :zlib.close(z)
                # IO.binwrite(file_handler, :erlang.list_to_binary([b1, b2]))
                IO.binwrite(file_handler, data)
                File.close(file_handler)
                Utils.zip_to_gz(file_name)
                read_headers(conn)
            {:more, binary, conn} ->
                #Utils.make_zip(:binary.bin_to_list(binary), file_name)
                #IO.binwrite(file_handler, :erlang.list_to_binary(:zlib.deflate(z, binary)))
                IO.binwrite(file_handler, binary)
                read_body(conn, file_name, file_handler, z)
            {:done, conn} ->
                conn
        end
    end
end
