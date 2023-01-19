class ErrorPolicy < Struct.new(:user, :error)

  def not_found?
    true
  end

  def unacceptable?
    true
  end

  def internal_server_error?
    true
  end
end
