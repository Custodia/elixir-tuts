defmodule DoorTest do
  use ExUnit.Case, async: true
  doctest Portal.Door
  alias Portal.Door

  test "start_link starts a GenServer with the given name" do
    Door.start_link(:green)
    pid  = GenServer.whereis(:green)
    assert pid != nil
  end

  test "Doors are spawned with a empty list as contents" do
    Door.start_link(:orange)
    assert Door.get(:orange) == []
  end

  test "Pushing values to a door works" do
    Door.start_link(:blue)
    assert Door.get(:blue) == []
    Door.push(:blue, 1)
    Door.push(:blue, 2)
    Door.push(:blue, 3)
    assert Door.get(:blue) == [3,2,1]
  end

  test "Popping values from doors works" do
    Door.start_link(:sodiepop)
    assert Door.get(:sodiepop) == []
    Door.push(:sodiepop, 1)
    Door.push(:sodiepop, 2)
    Door.push(:sodiepop, 3)
    assert Door.pop(:sodiepop) == { :ok, 3 }
    assert Door.get(:sodiepop) == [2,1]
  end

end
