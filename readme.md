# File
* main.rb
The running script for running_transcript.txt

* running_transcript.txt
The running output of main.rb

* movie_data.rb
The source code for the movie assignment

# Questions
### Predict the ranking that a user U would give to a movie M.
Find the 10 most users who has most similar taste with user U based on current data, and then average those 10 ranks made by those 10 people about movie M to represent the ranking for movie M by user U.

### Dose this algorithm scale?
Not quite. Since the algorithm I use to compute the similarity is proportional to the size of the data, as it scale up, the computation time might be huge and breaks the whole system.

### What factors determine the execution time of your “most_similar” and “popularity_list” algorithms.
It's the dataset's size. When the movie size get larger, the popularity method used in most_similar method need more time as well as the pupularity method used in popularity_list. In addition, when user size get larger, teh mose_similar and pupularity_list gets slower too.
