require 'json'

class SSE
  def initialize io
    @io = io
  end

  def write object, options = {}
    options.each do |k, v|
      @io.write "#{k}: #{v}\n"
    end
    @io.write "data: #{object.to_json}\n\n"
  end

  def close
    @io.close
  end
end