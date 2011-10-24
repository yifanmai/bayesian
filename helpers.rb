def get_filenames(dirname)
  filenames = []
  dir = Dir.new dirname
  dir.each do |filename|
    if File.file? dirname + filename
      filenames.push dirname + filename
    end
  end
  return filenames
end

def make_folds(items, num_folds)
  num_items = items.length
  fold_indices = [0]
  (1...num_folds).each do |i|
    fold_indices.push((num_items.to_f * i.to_f / num_folds.to_f).floor)
  end
  fold_indices.push(num_items)
  folds = []
  (0...num_folds).each do |i|
    startIndex = fold_indices[i]
    endIndex = fold_indices[i + 1]
    folds.push(items[startIndex...endIndex])
  end
  return folds
end
