defmodule SpeedoTest do
  use ExUnit.Case

  test "initial reading provides no speed indication" do
    assert {_speedo, nil} = accumulate([1_000_000_000])
  end

  test "a second reading provides an RPM reading" do
    assert {_speedo, 1.0} =
             accumulate([
               1_000_000_000,
               2_000_000_000
             ])
  end

  test "a third reading provides RPM as an average the 2 intervals" do
    assert {_speedo, 0.5} =
             accumulate([
               1_000_000_000,
               2_000_000_000,
               5_000_000_000
             ])
  end

  test "a fourth reading provides RPM as an average the 3 intervals" do
    assert {_speedo, 1.0} =
             accumulate([
               1_000_000_000,
               2_000_000_000,
               2_100_000_000,
               4_000_000_000
             ])
  end

  test "a fifth reading provides RPM as an average the last 3 intervals" do
    assert {_speedo, 2.0} =
             accumulate([
               1_000_000_000,
               6_500_000_000,
               7_000_000_000,
               7_500_000_000,
               8_000_000_000
             ])
  end

  test "additional readings just keep the last 3" do
    assert {_speedo, 1.0} =
             accumulate([
               1_000_000_000,
               6_500_000_000,
               7_000_000_000,
               7_500_000_000,
               8_000_000_000,
               9_000_000_000,
               10_000_000_000,
               11_000_000_000,
               12_000_000_000,
               13_000_000_000
             ])
  end

  defp accumulate(timestamps) do
    Enum.reduce(timestamps, Speedo.new(), fn
      timestamp, {speedo, _rpm} ->
        Speedo.reading(speedo, timestamp)

      timestamp, speedo ->
        Speedo.reading(speedo, timestamp)
    end)
  end
end
