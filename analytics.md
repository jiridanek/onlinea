## Ideas about the analytics pipeline

* downloading in batch takes up to 1 hour and requires entering captcha

* do not go thread by thread but open a list of all messages in a forum instead
* do incremental updates from RSS or notification e-mails. RSS would be preferred. Or just grab new messages from all forums. If I read something, it won't show up. Every day do a full update,

* saving changes as either full objects or key value pairs and recomputing the whole thing afterwards. materialized view for the current state.

* interactive visualization for dashboard: počet neobodovaných neokomentovaných příspěvků, graf čas napsání a stáří
* pro moderátory přehled aktivity jejich a studentů
* počet opravených příspěvků podle moderátora, dalo by možnost sdílet skupiny, protože bude přehled, kolik kdo opravil. problém, nárazy při dedlajnech, kdy ten přehled nebude

* buď stahovat domů, protože Dart, nebo metacentrum naplánovat job každou hodinu a velký job jednou za den / dva dny a import do bloků jednou za týden (co mají studenti kontrolovat musí být na appenginu, khan duolingo ec atd) a pokud chci testy, tak taky tam
* export z metacentra na appengine? proč ne, tam problémy nejsou. alespoň budu moct v Datastore mít jen data co potřebuju na prezentování v UI a nic jiného

## Plan

I have some Dart code that optionally depends on Postgresql for caching and some R code. Dart I can make run, R is already at Metacentrum, Postgresql should be doable too. Prescheduling every hour and every day seems possible too.

I need to write code for the updates and make analytics use old data plus all the updates. Meaning I can no longer start from raw pages, but have to use previous results.

class DoSomeAnalyticsStuff {
    parseThroughEverything {
    
    }
    
    applyUpdate {
    
    }
}

Do it either in Dart or in the Database (dart stores posts and I take the latest entry for each since the latest full download (inclusive). Or reparse the incremental downloads in Dart. It is actually quick because there is not that much data. I guess store both raw data and results and then combine, not reparse. Can use the DB to do that. Granularity? Probably store each forum message as a row. And each notebook version as a row or each discussion feedback as a row? The latter, probably. I have to also check if feedback was deleted, probably. Actually no, I will always reparse all feedback, so it does not arise. Deleted messages? Indirection, have an index of messages and a table with the messages itself. Always add to the index, not to the messages, unless there is a different version. Then the messages table holds only the actual messages.

I will miss deleted messages because the RSS does not tell me about that, maybe no point in worrying about it.

Instead of incremental storage may create actual forum history, with all intermediate versions. meaning merging the hourly updates into the single archival table with deletion date estimated at the time of a full update, possibly dropping table for the updates later.

Message: id, event, path, subject, text, author, cdate, mdate, uživatelske hodnoceni

id event details
and in details table keep all the rest?

if I ever wanted to keep the current view in a table, it would be more elegant to have the details table for both uses

### Conclusion

Have events table and details table, even full updates do not write all from scratch but update the database. I can do ocasionally a clean run to check it is working properly. (the full history would have deleted posts and changes that the clean run misses)

I will still cache all http requests of course -- sorting query attributes might be a good practice

I will send results to AppEnglne


