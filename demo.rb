require './helpers.rb'
require './bayesian.rb'

# CONFIGURATION: Fill in the {train, test} {spam, ham} directories here

dirnames = { :train => {}, :test => {} }
dirnames[:train][:spam] = ['spam/']
dirnames[:train][:ham] = ['easy_ham/']
dirnames[:test][:spam] = ['spam_2/']
dirnames[:test][:ham] = ['easy_ham_2/']

# Collate all filenames
filenames = { :train => {}, :test => {} }
[:train, :test].each do |stage|
  [:spam, :ham].each do |label|
    filenames[stage][label] = []
    dirnames[stage][label].each do |dirname|
      filenames[stage][label].concat(get_filenames(dirname))
    end
  end
end
  
# Train filter
puts 'Training...'
filter = BayesianFilter.new
[:spam, :ham].each do |label|
  filenames[:train][label].each do |filename|
    message = IO.read filename
    filter.add_message(message, label)
  end
end

# Test filter
puts 'Testing...'
pred_count = {
  :spam => { :spam => 0, :ham => 0 },
  :ham => { :spam => 0, :ham => 0 }
  }
[:spam, :ham].each do |ground_truth|
  filenames[:test][ground_truth].each do |filename|
    message = IO.read filename
    pred = filter.predict_label(message)
    pred_count[ground_truth][pred] += 1
  end
end

true_positive_rate = pred_count[:spam][:spam].to_f / (pred_count[:spam][:spam] + pred_count[:spam][:ham]).to_f
false_positive_rate = pred_count[:ham][:spam].to_f / (pred_count[:ham][:spam] + pred_count[:ham][:ham]).to_f
puts 'True positive rate: %.3f' % true_positive_rate
puts 'False positive rate: %.3f' % false_positive_rate
