import CatSolver
import Scheduler

to_process = File.ls!

Enum.each 1..10, fn num_processes ->
  { time, result } = :timer.tc(
    Scheduler, :run,
    [num_processes, CatSolver, :cat, to_process]
  )

  if num_processes == 1 do
    IO.puts inspect result
    IO.puts "\n #     time (s)"
  end
  :io.format "~2B     ~.2f~n", [num_processes, time/1000000.0]
end
