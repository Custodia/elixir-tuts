defmodule Weatherapp.WeatherService do

  @moduledoc """
  Fetch and parse data from the US weather.gove site.
  """

  @doc """
  Fetch the latest weather information of a given state.
  """
  def fetch_state_weather(state) do
    state_weather_url(state)
    |> HTTPoison.get()
  end

  @doc """
  Get the URL for the weather information API for the given state.
  """
  def state_weather_url(state) do
    "http://w1.weather.gov/xml/current_obs/#{state}.xml"
  end

end
