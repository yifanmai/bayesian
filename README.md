# Bayesian Filter

This is a spam filter that implements a classic Naive Bayes classifier with Laplace smoothing. No text preprocessing is used. It is almost entirely vanilla except for one modification: it truncate the word occurrence vector to the 10 most spam-like words and the 10 most ham-like words before calculating the posterior probabilities.

## Usage

See demo.rb for an example of usage.

    require 'bayesian.rb'
    filter = BayesianFilter.new

    # Train
    filter.add_message('Nigerian officials need your assistance', :spam)
    filter.add_message('Hi, how are you doing lately?', :ham)

    # Settings
    filter.spam_threshold = 0.5
    filter.spam_prior = 0.78

    # Test
    prediction = filter.predict_spam('Is this email message spam?')  

## Performance

To measure the performance of the filter, we use five-fold cross-validation. The dataset is split into fifths. For each trial, we train the filter on four-fifths of the dataset, and then test the filter on the remaining one-fifth. We then average the true positive rate and false positive rates across all trials. The cross-validation script can take up to several minutes to run.

### Data sources

* Spam dataset: http://spamassassin.apache.org/publiccorpus/20050311_spam_2.tar.bz2
* Ham dataset: http://spamassassin.apache.org/publiccorpus/20030228_easy_ham_2.tar.bz2

### Results

* True positive rate: 97.9%
* False positive rate: 2.6%

## References

* http://en.wikipedia.org/wiki/Bayesian_spam_filtering
* http://www.paulgraham.com/spam.html

## Notes

Hi Stripe! I baked this filter for you. Enjoy.