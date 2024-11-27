class ErrorSerializer
  def initialize(message, status = :unprocessable_entity)
    @message = message
    @status = status

  end

  def as_json(*)
    {
      status: @status,
      message: @message
    }
  end
end