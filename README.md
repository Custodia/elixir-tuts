## Purpose

Trying to learn elixir through tutorials and a few books.
This repo contains solved exercises, applications and notes on some
cool stuff I've found in elixir.

I don't want 20 different repositories for things I do while learning
but I still want to record progress and what not so making one massive
repo seems like a solution.

The commit messages are overly descriptive, trying to better myself in writing
good commit messages.

## Todo

* Make an app that fetches and formats xml from a site.
  * #1 candidate atm: http://w1.weather.gov/xml/current_obs/KDTO.xml
  * Meh..


* Implement a Djikstra service
  * Use protocols so that any type could be accepted
    * accessible?(loc1, loc2)
    * distance(loc1, loc2)
  * Maybe extend this to the reaktor challenge
    * Api for the challenge is down though so get problem/solution data
    somewhere and make comprehensive tests


* Implement a Telegram bot in elixir
  * Extend this into a telegram bot api?
  * Use phoenix?
