Have to learn some statistics ;)

Read what Pelanek wrote about Tutor

Check out the course on Coursera I did about half of it a year ago. And maybe Ng too.

Import questions (with IDs into the system) and with data from previous years -- difficulty. Will have to be able to recompute that easilly, with new answer possibilities, or discard some previous answers. Meaning I must store all answers. Recompute either on appengine in a queued job or outside and then upload. Recomputing is going to be manual, so outside. Log where? Regular appengine logs, datastore, bigquery, storage?

Have api, with CRFD protection sessions, Angular 2 frontend. I need a context for each user i guess for recomputation. If conflict, I have to merge, meaning I have to store some of users previous actions, all since a db write. I would have to write to datastore for every request it seems. Lets try the simplest and then improve.

We did not start the flamewar, some simple rules for item selection

(show new only after student answers previous one correctly... make it look intelligent... actual repetition? do all in js, send questions and answers to client, then send each answer and final result; allows cheating, but so what)
