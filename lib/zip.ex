defmodule Zip do
  use GenServer

  def start_link(state) do
    IO.inspect("it's work", label: "it's work")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

end
