# Cars REST API

## Solution and some assumptions

For this API I have created two models using Ecto: Cars and Subscriptions.
I assumed that the subscription has a relation with the cars, since  a car can have many subscriptions so that we can keep tracking a history.

**IMPORTANT:** I did some assumtions like the currency should be present as a parameter. Also added a field which is `started_at` so from my point of view a car can have a subscription but is available immediately as soon as it didn't start. I also assumed that the field `available_from` is calculated based on the `started_at` field, right now it's only supporting "monthly" that's why you will see I just calculate a month ahead from when it has started to be available again. Of course there is more logic that needs to be added like ending the subscription and updating the availability again, but didn't want to go furtherer and complicate it more. Lets also say that the subscription becomes obvious that should be a separated service and we would potencially have a subscriber waiting for a new car being rented and enqueuing a new message to assocciate a subscription to it.

# Documentation

Am more used to Swagger but am not a fun of it. In Elixir projects I used ExDocs adding the documentation at a controllers level. That's what I did right now, in order to understand the endpoints just go to the controllers where I included samples of calls. Didn't add ExDocs but there it's.

# Missing points due to time

* On the GET cars API add the possibility to do a sort by price, year, maker or availability - **I missed this point since don't have more time to spend on it**
* Regarding subscritions it should include more filters in GET cars endpoint in order to be able to retrieve only cars where subscription has started or those available right now only
* Test coverage - **It's roughly all covered but of course more needs to be covered**
* Code analisys - **As Rubocop in Ruby when working in Elixir I used Credo and Sobelow for code analysis, didn't include but just saying am aware of that**
* Regarding the Date fields I would recieve them as milliseconds coming from utc date times and them parsing them back before storing it
* I usually create a mix task or seed for testing, unfortunatelly didn't have the time, sorry

## Start up

To start your Phoenix server:

  * Install deps with `mix deps.get`
  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
