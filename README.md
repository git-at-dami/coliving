# Tech test

In this test you will code imaginary features for a coliving management system.

What matters is that you implement the features as if you were part of a team building a production app, keeping in mind that the code will be maintained by other people. It's not just about making it work.

If you have doubts about what is asked exactly, make a decision and carry on, the details don't matter much. Don't hesitate to add comments to explain your thought process, choices, difficulties, alternative solutions etc. The thought process matters more than the code. If you're really stuck, ping us.

You can use gems.

No need to deploy anything, your app should just run locally.

When you're done, push your code to a GitHub repo (don't fork this one) and ping us!

## Setup

Start a Rails app in API config, with whatever SQL db engine you want. Don't sweat the details.

Set up a Studio model (with its table).

Set up a Stay model (with its table) that belongs to Studio, with a start date attribute and an optional end date attribute.

Set up seeds to create studio1 and studio2, and then the following stays:

- studio1, start date 01/01/2024, end date 08/01/2024
- studio1, start date 16/01/2024, end date 24/01/2024
- studio2, start date 05/01/2024, end date 10/01/2024
- studio2, start date 15/01/2024, end date 20/01/2024
- studio2, start date 21/01/2024, end date 25/01/2024

NB: within a studio, stays can't overlap, but no need to enforce this.

## Question 1

Implement an endpoint that responds with a JSON description of all the absences (dates between which the studio's tenant is absent there) in the db, for all studios. An absence is a studio, a start date and an end date (not a list of dates).

Here is a schematic example for one studio:

```
Existing stays:             |---[--]------[-]---
Resulting absences:         |[-]----[----]---[--
```

NB: we count days, not nights, which means if a stay ends on date X, the next absence starts on date X + 1, and vice-versa.

NB2: the residence opens on 01/01/2024, so what happens before doesn't matter, an absence can start on that date at the earliest.

## Question 2

Implement an endpoint to which the client can post a JSON payload describing absences.

- studio1, start date 05/01/2024, end date 20/01/2024
- studio2, start date 01/01/2024, end date 12/01/2024

We want the stays in db to be udpated to reflect these absences. We also want an appopriate response.

Here is a schematic example for one studio:

```
Existing stays:             |---[-----]---[--------
Absences sent by client:    |-------[---]----[-]---
Updated stays:              |---[--]------[-]---[--
```
