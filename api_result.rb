##
# API接口调用的返回结果
#   code: 错误代码 0 - 成功; 其他为错误
#   msg:  错误代码的相应描述信息
#   data: 成功(code为0)时, API返回的数据对象, 以Hash方式传递
#
class ApiResult
  attr_accessor :code, :msg, :data
  include Constants::Error::Http

  def initialize(code = 0, msg = nil, data = {})
    self.code = code
    self.msg = msg.nil? ? Constants::ERROR_MESSAGES[code] : msg
    self.data = data
  end

  ##
  # 是否为失败结果
  def failure?
    code != SUCCESS_CALL
  end

  ##
  # 返回给定的错误码的api result
  def self.error_result(code, msg = nil, data = {})
    new(code, msg, data)
  end

  ##
  # 返回缺省的成功对象, 用于避免内存中生成过多的默认成功实例
  def self.success_result
    @success_api_result ||= new.freeze
  end

  ##
  # 根据给定的data, 返回成功的api result
  def self.success_with_data(data)
    new(SUCCESS_CALL, nil, data)
  end

  # def to_s
  #   "ApiResult{code: #{code}, msg: '#{msg}', data: #{data.inspect}"
  # end
end
