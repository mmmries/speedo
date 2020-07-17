defmodule Speedo.Monitor do
  use GenServer
  alias Circuits.GPIO
  require Logger

  def subscribe(pin_number) do
    Registry.register(Speedo.Registry, pin_number, [])
  end

  def start_link(pin_number) do
    GenServer.start_link(__MODULE__, pin_number)
  end

  @impl GenServer
  def init(pin_number) do
    {:ok, gpio} = GPIO.open(pin_number, :input)
    :ok = GPIO.set_interrupts(gpio, :rising)
    {:ok, {gpio, pin_number, Speedo.new()}}
  end

  @impl GenServer
  def handle_info({:circuits_gpio, pin_number, timestamp, _value}, {gpio, pin_number, speedo}) do
    case Speedo.reading(speedo, timestamp) do
      {speedo, nil} ->
        {:noreply, {gpio, pin_number, speedo}}

      {speedo, rps} ->
        publish_rps(pin_number, rps)
        {:noreply, {gpio, pin_number, speedo}}
    end
  end

  def handle_info(other, state) do
    Logger.error("#{__MODULE__} received unexpected message: #{inspect(other)}")
    {:noreply, state}
  end

  defp publish_rps(pin_number, rps) do
    Registry.dispatch(Speedo.Registry, pin_number, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:speedo_rps, pin_number, rps})
    end)
  end
end
