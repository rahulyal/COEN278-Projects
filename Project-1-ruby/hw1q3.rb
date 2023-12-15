class Compress
    attr_accessor :compressed_sentence, :index_array
  
    def initialize(sentence)
        @compressed_sentence = []
        @index_mapping = {}
        words = sentence.split
        compressed_index = 0

        words.each do |word|
            unless @index_mapping.key?(word)
                @compressed_sentence << word
                @index_mapping[word] = compressed_index
                compressed_index += 1
            end
        end

        @index_array = words.map { |word| @index_mapping[word] }
    end

    def decompress
        original_sentence = @index_array.map { |index| @compressed_sentence[index] }
        original_sentence.join(' ')
    end
end

#example
sentence = "i love you but do you love me"
compressor = Compress.new(sentence)
puts "Compressed Sentence: #{compressor.compressed_sentence}"
puts "Index Array: #{compressor.index_array}"
puts "Decompressed Sentence: #{compressor.decompress}"

#example
sentence = "this is real is this real though"
compressor = Compress.new(sentence)
puts "Compressed Sentence: #{compressor.compressed_sentence}"
puts "Index Array: #{compressor.index_array}"
puts "Decompressed Sentence: #{compressor.decompress}"