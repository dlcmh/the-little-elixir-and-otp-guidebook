defmodule ThySupervisor do
  use GenServer

  ## API ##
  def start_link(child_spec_list) do
    # child_spec_list looks like [{ThyWorker, :start_link, []}, {ThyWorker, :start_link[]}]
    GenServer.start_link(__MODULE__, [child_spec_list])
  end

  # Takes the supervisor pid & child specification and attaches the child to the supervisor
  def start_child(supervisor, child_spec) do
    GenServer.call(supervisor, {:start_child, child_spec})
  end

  def terminate_child(supervisor, pid) when is_pid(pid) do
    GenServer.call(supervisor, {:terminate_child, pid})
  end

  # Sometimes it’s helpful to manually restart a child process.
  # When you want to do so, you need to supply the process id and the child specification.
  # Why do you need the child specification passed in along with the process id?
  # Because you may want to add more arguments, and they have to go in the child specification.
  # The restart_child/2 private function is a combination of terminate_child/1 and start_child/1.
  def restart_child(supervisor, pid, child_spec) when is_pid(pid) do
    GenServer.call(supervisor, {:restart_child, pid, child_spec})
  end

  def count_children(supervisor) do
    GenServer.call(supervisor, :count_children)
  end

  def which_children(supervisor) do
    GenServer.call(supervisor, :which_children)
  end

  ## Callback Functions ##
  def init([child_spec_list]) do
    Process.flag(:trap_exit, true) # Enables the supervisor process to trap exit signals from its children as normal messages
    state =
      child_spec_list # child_spec_list looks like [{ThyWorker, :start_link, []}, {ThyWorker, :start_link[]}]
      |> start_children # returns eg list of tuples [{<0.82.0>, {ThyWorker, :init, []}}, {<0.84.0>, {ThyWorker, :init, []}}]
      # |> Enum.into(HashDict.new) # HashDict.new/0 is deprecated
      |> Enum.into(%{}) # previous list of tuples is transformed into a Map, with the pids of the child processes as the keys and the child specifications as the values
    {:ok, state}
  end

  def handle_call({:start_child, child_spec}, _from, state) do
    case start_child(child_spec) do
      {:ok, pid} ->
        new_state = state |> Map.put(pid, child_spec)
        {:reply, {:ok, pid}, new_state}
      :error ->
        {:reply, {:error, "error starting child"}, state}
    end
  end

  def handle_call({:terminate_child, pid}, _from, state) do
    case terminate_child(pid) do
      :ok ->
        new_state = state |> Map.delete(pid)
        {:reply, :ok, new_state}
      :error ->
        {:reply, {:error, "error terminating child"}, state}
    end
  end

  def handle_call({:restart_child, old_pid}, _from, state) do
    case Map.fetch(state, old_pid) do
      {:ok, child_spec} ->
        case restart_child(old_pid, child_spec) do
          {:ok, {pid, child_spec}} ->
            new_state =
              state
              |> Map.delete(old_pid)
              |> Map.put(pid, child_spec)
            {:reply, {:ok, pid}, new_state}
          :error ->
            {:reply, {:error, "error restarting child"}, state}
        end
      _ ->
        {:error, :ok, state}
    end
  end

  def handle_call(:count_children, _from, state) do
    {:reply, Map.size(state), state}
  end

  def handle_call(:which_children, _from, state) do
    {:reply, state, state}
  end

  # When a child is forcibly killed using Process.exit(pid, :kill),
  # the supervisor receives a message in the form of {:EXIT, pid, :killed}.
  # In order to handle this message, the handle_info/3 callback is used.
  def handle_info({:EXIT, pid, :killed}, state) do
    new_state = state |> Map.delete(pid)
    {:noreply, new_state}
  end

  ## Handling crashes - 2 cases
  # Case 1 - Doing nothing when a child process exits normally
  def handle_info({:EXIT, pid, :normal}, state) do
    new_state = state |> Map.delete(pid)
    {:noreply, new_state}
  end

  # Case 2 - restart a child process that exits normally
  def handle_info({:EXIT, old_pid, _reason}, state) do
    case Map.fetch(state, old_pid) do
      {:ok, child_spec} ->
        case restart_child(old_pid, child_spec) do
          {:ok, {pid, child_spec}} ->
            new_state =
              state
              |> Map.delete(old_pid)
              |> Map.put(pid, child_spec)
            {:noreply, new_state}
          :error ->
            {:noreply, state}
        end
      _ ->
        {:noreply, state}
    end
  end

  # Terminating the supervisor - children need to be terminated first
  def terminate(_reason, state) do
    terminate_children(state)
    :ok
  end


  ## Private Functions ##
  defp start_children([child_spec|rest]) do
    case start_child(child_spec) do
      {:ok, pid} ->
        [{pid, child_spec}|start_children(rest)]
      :error ->
        :error
    end
  end

  defp start_children([]), do: []

  defp start_child({mod, fun, args}) do
    case apply(mod, fun, args) do
      pid when is_pid(pid) ->
        Process.link(pid)
        {:ok, pid}
      _ ->
        :error
    end
  end

  defp restart_child(pid, child_spec) when is_pid(pid) do
    case terminate_child(pid) do
      :ok ->
        case start_child(child_spec) do
          {:ok, new_pid} ->
            {:ok, {new_pid, child_spec}}
          :error ->
            :error
        end
      :error ->
        :error
    end
  end

  defp terminate_children([]) do
    :ok
  end

  defp terminate_children(child_specs) do
    child_specs |> Enum.each(fn {pid, _} -> terminate_child(pid) end)
  end

  defp terminate_child(pid) do
    Process.exit(pid, :kill)
    :ok
  end
end
