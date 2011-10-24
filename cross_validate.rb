require './helpers.rb'
require './bayesian.rb'

# CONFIGURATION: Fill in the {spam, ham} directories here

dirnames = {}
dirnames[:spam] = ['spam_2/']
dirnames[:ham] = ['easy_ham_2/']

filenames = {}
filenames[:spam] = []
filenames[:ham] = []

num_folds = 5
filename_folds = {}

# Collate all filenames
[:spam, :ham].each do |label|
  dirnames[label].each do |dirname|
    filenames[label].concat(get_filenames(dirname))
  end
  filename_folds[label] = make_folds(filenames[label], num_folds)
end


pred_count = {
  :spam => { :spam => 0, :ham => 0 },
  :ham => { :spam => 0, :ham => 0 }
  }

# Run trials
(0...num_folds).each do |trial_index|
  puts 'Trial %d' % (trial_index + 1)
  
  # Build folds
  train_filenames = {}
  test_filenames = {}
  [:spam, :ham].each do |label|
    train_filenames[label] = []
    test_filenames[label] = []
    filename_folds[label].each_index do |i|
      train_filenames[label].concat(filename_folds[label][i]) if i % num_folds != trial_index
      test_filenames[label].concat(filename_folds[label][i]) if i % num_folds == trial_index
    end
  end
  
  # Train filter
  puts 'Training...'
  filter = BayesianFilter.new
  [:spam, :ham].each do |label|
    train_filenames[label].each do |filename|
      message = IO.read filename
      filter.add_message(message, label)
    end
  end

  # Test filter
  puts 'Testing...'
  [:spam, :ham].each do |ground_truth|
    test_filenames[ground_truth].each do |filename|
      message = IO.read filename
      pred = filter.predict_label(message)
      pred_count[ground_truth][pred] += 1
    end
  end
end

puts "Done! Here are the results."
true_positive_rate = pred_count[:spam][:spam].to_f / (pred_count[:spam][:spam] + pred_count[:spam][:ham]).to_f
false_positive_rate = pred_count[:ham][:spam].to_f / (pred_count[:ham][:spam] + pred_count[:ham][:ham]).to_f
puts 'True positive rate: %.1f' % (true_positive_rate * 100.0)
puts 'False positive rate: %.3f' % (false_positive_rate * 100.0)
