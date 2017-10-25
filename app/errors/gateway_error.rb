class GatewayError < StandardError
  def initialize(gateway = 'Gateway', msg='Service is not available')
    super("#{gateway}: #{msg}")
  end
end