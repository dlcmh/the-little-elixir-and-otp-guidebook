defmodule Ring do
  @moduledoc """
  Documentation for Ring.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Ring.hello
      :world

  """
  def hello do
    :world
  end

  # The return value of Ring.create_processes/1 is a list of spawned pids
  def create_processes(n) do
    1..n |> Enum.map(fn _ -> spawn(fn -> loop() end) end)
  end

  def loop do
    receive do
      {:link, link_to} when is_pid(link_to) ->
        Process.link(link_to)
        loop()

      ## Letting the process handle :EXIT & :DOWN messages
      # Handles a message to trap exits
      :trap_exit ->
        Process.flag(:trap_exit, true)

      :crash ->
        1/0

      # Handles a message to detect :DOWN messages
      {:EXIT, pid, reason} ->
        IO.puts "#{inspect self()} received {:EXIT, #{inspect pid}, #{reason}}"
        loop()
    end
  end

  ## Setting up the ring of links using recursion
  def link_processes(procs) do
    link_processes(procs, [])
  end

  def link_processes([proc_1, proc_2|rest], linked_processes) do
    # iex(1)> [a, b|rest] = [1,2,3,4,5]
    # a => 1
    # b => 2
    # rest => [3, 4, 5]
    send proc_1, {:link, proc_2}
    link_processes [proc_2|rest], [proc_1|linked_processes]
  end

  def link_processes([proc|[]], linked_processes) do
    first_process = linked_processes |> List.last
    send proc, {:link, first_process}
    :ok
  end
end
