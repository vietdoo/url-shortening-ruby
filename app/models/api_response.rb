class ApiResponse
  attr_reader :status, :data, :message

  def initialize(status:, data: {}, message: nil)
    @status = status
    @data = data
    @message = message
  end

  def to_h
    { status: status, data: data, message: message }
  end
end