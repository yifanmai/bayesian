require './helpers.rb'

class BayesianFilter
  attr_accessor :spam_prior, :spam_threshold
  
  def initialize
    @spam_prior = 0.5
    @spam_threshold = 0.5
    
    @num_messages = {}
    @num_messages[:spam] = 0
    @num_messages[:ham] = 0
    
    @word_counts = {}
    @word_counts[:spam] = {}
    @word_counts[:ham] = {}
  end
  
  def tokenize(message)
    return message.split
  end
  
  def predict_label(message)
    if spam_probability(message) > @spam_threshold
      return :spam
    else
      return :ham
    end
  end
  
  def spam_probability(message)
    words = tokenize message
    occurences = {}
    words.each do |word|
      occurences[word] ||= true
    end
    
    prior = { :spam => @spam_prior, :ham => 1 - @spam_prior }
    word_evidence = []
    
    occurences.each do |word, v|
      posterior = {}
      [:spam, :ham].each do |label|
        count = @word_counts[label][word].nil? ? 0 : @word_counts[label][word]
        posterior[label] = (count + 1).to_f / (@num_messages[label] + 2).to_f
      end
      metric = (posterior[:spam] * prior[:spam]) / (posterior[:spam] * prior[:spam] + posterior[:ham] * prior[:ham])
      evidence = {:posterior => posterior, :metric => metric}
      word_evidence.push evidence
    end
    top_evidence = []
    top_n = 10
    top_n = top_n < word_evidence.length ? top_n : word_evidence.length
    word_evidence = word_evidence.sort_by {|x| x[:metric]}
    top_evidence.concat word_evidence[0...top_n]
    #word_evidence.reverse!
    top_evidence.concat word_evidence[-top_n..-1]
    posterior = {}
    [:spam, :ham].each do |label|
      posterior[label] = top_evidence.inject(1){|mul, e| mul * e[:posterior][label]}
    end
    return (posterior[:spam] * prior[:spam]) / (posterior[:spam] * prior[:spam] + posterior[:ham] * prior[:ham])
  end

  def add_message(message, label)
    words = tokenize message
    occurences = {}
    words.each do |word|
      occurences[word] ||= true
    end
    occurences.each do |word, v|
      @word_counts[label][word] = 0 if @word_counts[label][word].nil?
      @word_counts[label][word] += 1
    end
    @num_messages[label] += 1
  end
  
end
