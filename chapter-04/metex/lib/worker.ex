defmodule Metex.Worker do
  use GenServer # defines the callbacks required for GenServer

  @name MW # name is Elixir.MW; @name stores the name for this GenServer so that we don't always have to refer to the pid

  ## Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: MW]) # initializes the server with a registered name
  end

  def get_temperature(location) do
  # def get_temperature(pid, location) do
    # GenServer.call(pid, {:location, location})
    GenServer.call(@name, {:location, location}) # pass @name instead of pid
  end

  def get_stats do
  # def get_stats(pid) do
    # GenServer.call(pid, :get_stats)
    GenServer.call(@name, :get_stats) # pass @name instead of pid
  end

  def reset_stats do
  # def reset_stats(pid) do
    # GenServer.cast(pid, :reset_stats)
    GenServer.cast(@name, :reset_stats) # pass @name instead of pid
  end

  def stop do
  # def stop(pid) do
    # GenServer.cast(pid, :stop)
    GenServer.cast(@name, :stop) # pass @name instead of pid
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}°C", new_stats}
      _ ->
        {:reply, :error, stats}
    end
  end

  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end

  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  def terminate(reason, stats) do
    # We could write to a file, database, etc
    IO.puts "server terminated because of #{inspect reason}"
    inspect stats
    :ok
  end

  # handle_info/2 handles any out-of-band messages (messages that aren't handled by handle_call/3 or handle_cast/2)
  # we don't need to supply a client API counterpart for handle_info/2
  def handle_info(msg, stats) do
    IO.puts "received #{inspect msg}"
    {:noreply, stats}
  end


  ## Helper Functions
  defp temperature_of(location) do
    url_for(location) |> HTTPoison.get |> parse_response
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp apikey do
    "409144b5e5d7b490799a768f108bbc76"
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true ->
        Map.update!(old_stats, location, &(&1 + 1)) # equivalent to Map.update!(old_stats, location, fn(val) -> val + 1 end)
      false ->
        Map.put_new(old_stats, location, 1)
    end
  end
end
