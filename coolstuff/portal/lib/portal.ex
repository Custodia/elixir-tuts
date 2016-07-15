defmodule Portal do
  use Application

  defstruct [:left, :right]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Portal.Door, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :simple_one_for_one, name: Portal.Supervisor]
    Supervisor.start_link(children, opts)
  end


  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end


  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  def transfer(left, right, data) do

    Enum.each(data, fn item -> Portal.Door.push(left, item) end)

    %Portal{ left: left, right: right }
  end


  @doc """
  Pushes data to the right in the given `portal`.
  """
  def push_right(%Portal{ left: left, right: right} = portal) do
    alias Portal.Door

    case Door.pop(left) do
      :error -> :ok
      { :ok, h } -> Door.push(right, h)
    end

    portal
  end

  @doc """
  Pushes data to the left in the given `portal`.
  """
  def push_left(%Portal{ left: left, right: right} = portal) do
    alias Portal.Door

    case Door.pop(right) do
      :error -> :ok
      { :ok, h } -> Door.push(left, h)
    end

    portal
  end

end



defimpl Inspect, for: Portal do
  alias Portal.Door

  def inspect(%Portal{ left: left, right: right }, _) do
    left_door  = inspect(left)
    right_door = inspect(right)

    left_data  = inspect(Enum.reverse(Door.get(left)))
    right_data = inspect(Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.rjust(left_door, max)} <=> #{right_door}
      #{String.rjust(left_data, max)} <=> #{right_data}
    >
    """
  end
end
