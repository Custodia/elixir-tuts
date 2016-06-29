defmodule Weatherapp.WeatherService do

  @moduledoc """
  Fetch and parse data from the US weather.gove site.
  """

  require Logger

  @doc """
  Fetch the latest weather information of a given state.
  """
  def fetch_state_weather(state) do
    state_weather_url(state)
    |> HTTPoison.get()
    |> handle_response
  end


  @doc """
  Get the URL for the weather information API for the given state.
  """
  def state_weather_url(state) do
    "http://w1.weather.gov/xml/current_obs/#{state}.xml"
  end


  @doc """
  Handle the response from HTTPoison

  If response is :ok parse xml and return it.

  If response is something else log the error status and halt with 3.
  """
  def handle_response({ :ok, %{ status_code: 200, body: body } }) do
    Logger.info "Successfull response from the API"
    Logger.debug "Response body:"
    Logger.debug fn -> inspect(body) end
    { :ok, body }
  end

  def handle_response({ _, %{ status_code: status }}) do
    Logger.error "Error #{status} returned from the API"
    System.halt(3)
  end

end
