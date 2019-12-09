class ImageDecoder
  attr_reader :decoded

  def initialize filename, height, width
    @raw = load_data filename
    @height = height
    @width = width
    @chunked = @raw.scan /.{#{@width}}/
    @decoded = decode
  end

  def decode
    layers = []
    while @chunked.length > 0
      layers << decode_layer
    end
    layers
  end

  def decode_layer
    layer = []
    @height.times do
      layer << @chunked.shift
    end
    layer
  end

  def least_zeros_layer
    most_zeros, idx = 150, 0
    @decoded.each_with_index do |layer, i|
      if layer.join.count("0") < most_zeros
        most_zeros = layer.join.count("0")
        idx = i
      end
    end
    @decoded[idx]
  end

  def load_data filename
    raw = ""
    File.open filename do |file|
      file.each do |line|
        raw += line.chomp
      end
    end
    raw
  end
end

id = ImageDecoder.new './input', 6, 25
layer = id.least_zeros_layer
puts layer.join.count("1") * layer.join.count("2")