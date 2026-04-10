This repository contains the code for the analyses I ran for my writing sample. The goal of the project was to see how anti-Asian bias has changed in the wake of the pandemic.

I collected tweets mentioning Asia or Asian people from a year before the outbreak of COVID-19 to more than a year after the outbreak. I collected the number of articles published about the pandemic by the New York Times to identify the role of news media. I then created a binary variable categorizing each day into “pre outbreak” or a “post outbreak.” I conducted a sentiment analysis by regressing the sentiment of the collected tweets on whether they were published before or after the outbreak and on the number of articles published about the pandemic per day. I did the same with proportions of stereotypic words in the tweets. Finally, I conducted an implicit bias test using the Word Embedding Association Test (Caliskan et al., 2017).

To identify implicit bias, I followed the same procedure as Kurdi and colleagues (2019). I compared the difference between the vectors for my social category of interest (Asian people) and (i) vectors of warmth- and (ii) competence-conveying stereotypes about Asian people mentioned in the tweets. I then compared the difference between these two differences. The vectors were shuffled to create permutations of likely relationships in the vector space. Proportion of permutations where the effect size of the difference between the differences remained above 0 became our alpha value. 

These analyses can be implemented on the media consumed by individuals to computationally quantify the biases in those media. The effects of these biases on each individual’s attitudes can then be identified. People who consume media whose authors/creators change in their biases would be an especially interesting segment. By comparing people who:
• disengage when the authors/creators change in their attitudes and/or biases,
• don’t disengage,
• don’t encounter authors/creators who change and, therefore, don’t disengage, and
• don’t encounter authors/creators who change but still disengage,
we could identify which factors predict opinion change via consumption of contrary
content.

References:
Caliskan A, Bryson JJ and Narayanan A (2017) Semantics derived automatically from language corpora
contain human-like biases. Science 356(6334). American Association for the Advancement of Science: 183–
186.
Kurdi, B., Mann, T. C., Charlesworth, T. E., & Banaji, M. R. (2019). The relationship between implicit
intergroup attitudes and beliefs. Proceedings of the National Academy of Sciences, 116(13), 5862-5871.
