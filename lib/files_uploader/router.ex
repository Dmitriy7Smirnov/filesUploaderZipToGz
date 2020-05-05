# Routing
defmodule Router do
    use Plug.Router
    require Logger

    plug(:match)
    plug(:dispatch)

    # Show form
    get "/" do
        status = 200
        body = HtmlPage.get_page_with_form()
        send_resp(conn, status, body)
    end

    # Read files
    post "/fileHandler" do
        [content] = Plug.Conn.get_req_header(conn, "content-type")
        IO.inspect(content, label: "content-type")
        [length] = Plug.Conn.get_req_header(conn, "content-length")
        IO.inspect(length, label: "content-length")
        conn = Parser.read_headers(conn)
        status = 200
        body = "files were recieved"
        send_resp(conn, status, body)
    end

    # Catch-up
    match _ do
        send_resp(conn, 404, "Not found")
    end
end

