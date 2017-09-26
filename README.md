# asr-data
Data and code for a small project on meta-information from the American Sociological Review
#Author
Christopher Steven Marcum <cmarcum@uci.edu>
Originally compiled by Chris Marcum and archived at http://chrismarcum.com/wikka.php?wakka=PublicASRMethods
#Last modified
26 September 2017

#Details
All meta-information from 421 articles published in American Sociological Review between January 1, 2007 and June 9, 2017 was collected through the Thomson Reuters Web-of-Science API. Keyword sources were extracted from two fields in the database: the ID field, which encodes the publisher issued keywords and the DE field, which encodes the author supplied keywords printed with the manuscript. Each list of keywords was cleaned of punctuation and special characters and each keyword list was concatenated into a unified list of non-unique keywords (n=5,468) for tabulation. Authors were sourced from the AU fields. T

*For the keywords component:
The top 50 reoccurring keywords was then extracted after tabulation. The resulting candidate keywords (n>2000) were revised into a final unique set by the following procedure:
1) united states (n=117) and 2) sociology (n=20) were removed the candidate set.
2) A new candidate set was established.
3) From the new set, immediate analogs were combined into one term (arbitrarily selected from subset of analogs). For example, social networks (n=26) was combined with networks (n=32) and labor market (n=18) was combined with labor markets (n=14).
4) Steps 2 and 3 were repeated until no immediate analogs were found (4 times).

Finally, the top 50 was truncated at the nearest-lowest frequency tie (n=12) resulting in a 48 keyword list representing the 98% quantile of the frequency distribution, as estimated by an empirical cumulative distribution function. This step was done to reduce the burden of increasingly long lists of ties in this heavily right-tailed distribution. 

*For the collaboration component
Edges are drawn between authors when they both co-authored at least one paper between 2007 and 2017. Vertices are colored by induced subgraph. Isolates are suppressed for no particular reason. 

*Limitations
The final set of keywords is heavily conditioned on the initial ranking. This means that potentially analogous low frequency terms are not pooled. This results in two limitations to the final ranking: 1) keywords in the candidate set that could be combined with low frequency terms are under-weighted and, 2) analogous low frequency terms that would have resulted in a higher ranking keyword by combining do not appear in the final set. As there are only roughly 2000 unique terms, someone with more free time than I may wish to comb through and resolve these limitations.

One limitation of the co-authorship network is that it does not distinguish between single and multiple publication co-authorships. Another is that it is a ten year time aggregation. Finally, the entity resolution is quite dependent on unique last names and first initials (this is a result of Thomson Reuters not using research unique IDs). Thus, there would be no distinction between, for example, Nancy Martin and Nathan Martin and Susan Brown (UC-Irvine) and Susan L Brown (Bowling Green). Thanks to Omar Lizardo for pointing this last one out to me.


