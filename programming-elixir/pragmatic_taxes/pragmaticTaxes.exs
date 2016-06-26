defmodule PragmaticTaxes do

  def pp_tax_rates, do: [ NC: 0.075, TX: 0.08]

  def pp_orders, do: [
    [ id: 123, ship_to: :NC, net_amount: 100.00 ],
    [ id: 124, ship_to: :OK, net_amount:  35.50 ],
    [ id: 125, ship_to: :TX, net_amount:  24.00 ],
    [ id: 126, ship_to: :TX, net_amount:  44.80 ],
    [ id: 127, ship_to: :NC, net_amount:  25.00 ],
    [ id: 128, ship_to: :MA, net_amount:  10.00 ],
    [ id: 129, ship_to: :CA, net_amount: 102.00 ],
    [ id: 130, ship_to: :NC, net_amount:  50.00 ] ]

  def add_total_amounts(orders \\ pp_orders, tax_rates \\ pp_tax_rates) do
    tax_rates = Enum.into tax_rates, %{}
    for order <- orders, do: add_total_amount(order, tax_rates)
  end
  defp add_total_amount(order, tax_rates) do
    [ id: _, ship_to: to, net_amount: amount] = order
    tax = tax_rates[to]
    tax = tax || 0
    total_amount = amount * (1 + tax)
    order ++ [total_amount: total_amount]
  end

  defp parse_line(<< id::bitstring-size(24) >> <> ",:" <>
                  << ship_to::bitstring-size(16) >> <> "," <>
                  << net_amount::bitstring >>) do
    { id, _ } = Integer.parse(id)
    { net_amount, _ } = Float.parse(net_amount)
    [ id: id, ship_to: :"#{ship_to}", net_amount: net_amount ]
  end

  def parse_taxes(string) do
    File.open!(string)
    |> IO.stream(:line)
    |> Stream.drop(1)
    |> Stream.map(&parse_line/1)
    |> add_total_amounts(pp_tax_rates)
  end

end
