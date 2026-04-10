This repository contains the code for the analyses run for the study "Racializing a pandemic: Transmission of anti-Asian bias during Coronavirus on Twitter." The goal of the project was to see how anti-Asian bias has changed in the wake of the pandemic. 

Tweets mentioning Asia or Asian people from a year before the outbreak of COVID-19 to more than a year after the outbreak were collected. A binary variable categorizing each day into “pre outbreak” or a “post outbreak” was created. The number of articles published about the pandemic by the New York Times was also collected. 

I conducted a sentiment analysis by regressing the sentiment of the collected tweets on whether they were published before or after the outbreak and on the number of articles published about the pandemic per day. I did the same with proportions of stereotypic words in the tweets. Finally, I conducted an implicit bias test using word embeddings.

In order to identify implicit bias, I followed the same procedure as Kurdi and colleagues (2019). I obtained vectors of warmth- and competence-conveying stereotypes about Asian people that were mentioned in the tweets. I then compared the difference between the category vector and the warm stereotype vector to the difference between the category vector and the competent stereotype vector. The vectors were shuffled to create permutations of likely relationships in the vector space. Proportion of permutations where the effect size of the difference between the differences remained above 0 became our alpha value. 

These analyses can be implemented on the media consumed by our participants to computationally quantify the biases in those media. We can then identify the effects of these biases on each participant’s attitudes and biases. Participants who consume media whose authors/creators change in their biases would be an especially interesting segment. By comparing:
• participants who disengage when the authors/creators of the media they consume
change in their attitudes and/or biases,
• participants who don’t disengage,
• participants who don’t encounter authors/creators who change in their biases and
attitudes and, therefore, don’t disengage, and
• participants who do not encounter authors/creators who change in their biases and
attitudes and still disengage,
we can identify which factors predict opinion change via consumption of contrary content.

References:
Kurdi, B., Mann, T. C., Charlesworth, T. E., & Banaji, M. R. (2019). The relationship between implicit intergroup attitudes and beliefs. Proceedings of the National Academy of Sciences, 116(13), 5862-5871.
