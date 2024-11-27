require 'ostruct'

class UrlEncodeForm
  def initialize(params)
    @params = params
  end

  def valid
    if !validate_expiration_days.success?
      return OpenStruct.new(success?: false, message: validate_expiration_days.message)
    end
    return OpenStruct.new(success?: true)
  end

  def validate_expiration_days
    expiration_days = @params[:expiration_days]
    unless expiration_days.to_s.match?(/^\d+$/)
      return OpenStruct.new(success?: false, message: "Expiration days must be a valid number")  
    end

    if expiration_days.to_i <= 0 || expiration_days.to_i > 30
      return OpenStruct.new(success?: false, message: "Expiration days must be a positive number between 1 and 30")
    end
    
    return OpenStruct.new(success?: true)
  end

end