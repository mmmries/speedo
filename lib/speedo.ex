defmodule Speedo do
  defstruct readings: []

  def new, do: %__MODULE__{}

  @spec reading(%__MODULE__{}, non_neg_integer()) :: {%__MODULE__{}, float() | nil}
  def reading(%__MODULE__{readings: []}, timestamp) do
    speedo = %__MODULE__{readings: [timestamp]}
    {speedo, nil}
  end

  def reading(%__MODULE__{readings: readings}, timestamp) do
    {readings, average_interval} = accept(readings, timestamp)
    rpm = 1.0 / (average_interval / 1_000_000_000.0)

    speedo = %__MODULE__{
      readings: readings
    }

    {speedo, rpm}
  end

  defp accept([i1], timestamp) do
    interval = timestamp - i1
    {[i1, timestamp], interval}
  end

  defp accept([i1, i2], timestamp) do
    interval = timestamp - i1
    {[i1, i2, timestamp], interval / 2.0}
  end

  defp accept([i1, i2, i3], timestamp) do
    interval = timestamp - i1
    {[i2, i3, timestamp], interval / 3.0}
  end
end
