module Constants
  module Error
    module Http
      SUCCESS_CALL = 0
      HTTP_FAILED = 800

      HTTP_NO_CREDENTIAL = 801
      HTTP_INVALID_CREDENTIAL = 802
      HTTP_CREDENTIAL_NOT_MATCH = 803
      HTTP_TOKEN_EXPIRED = 804
      HTTP_LOGIN_REQUIRED = 805
      HTTP_ACCESS_FORBIDDEN = 806
      HTTP_INVALID_HEADER = 807
      HTTP_USER_BAN = 809

      HTTP_MAX = 899
    end

    module Common
      MISSING_PARAMETER = 1100001
      UNSUPPORTED_TYPE = 1100002
      DATABASE_ERROR = 1100003
      PARAM_FORMAT_ERROR = 1100004
      DATE_FORMAT_ERROR = 1100005
      NOT_FOUND = 1100006
      SYSTEM_ERROR = 1100007
      PARAM_VALUE_NOT_ALLOWED = 1100008
      ERROR_NOTICE = 1100009
    end

    module Sign
      EMAIL_FORMAT_WRONG = 1100011
      MOBILE_FORMAT_WRONG = 1100012
      MOBILE_ALREADY_USED = 1100013
      EMAIL_ALREADY_USED = 1100014
      PASSWORD_FORMAT_WRONG = 1100015
      USER_NOT_FOUND = 1100016
      PASSWORD_NOT_MATCH = 1100017
      VCODE_NOT_MATCH = 1100018
      VCODE_TYPE_WRONG = 1100019
      NICK_NAME_EXIST = 1100020
      UNSUPPORTED_RESET_TYPE = 1100021
      UNSUPPORTED_OPTION_TYPE = 1100022
      USER_ALREADY_EXIST = 1100023
      ACCOUNT_ALREADY_BIND = 1100024
    end

    module Race
      TICKET_SOLD_OUT = 1100031
      TICKET_UNSOLD = 1100032
      TICKET_NO_SELL = 1100033
      AGAIN_BUY = 1100039
      ENTITY_TICKET_SOLD_OUT = 1100037
      E_TICKET_SOLD_OUT = 1100040
      TICKET_END = 1100038
    end

    module Address
      NO_ADDRESS = 1100041
    end

    module Order
      CANNOT_CANCEL = 1110000
      CANNOT_PAY = 1110001
      PAY_ERROR = 1110002
      INVITE_CODE_NOT_EXIST = 1110003
      INVALID_ORDER = 1110004
      CANNOT_CONFIRM = 1110005
      SEVEN_DAYS_REFUND_ERROR = 1110006
      INVALID_REFUND_PRICE = 1110007
      CANNOT_REFUND = 1110008
      OVER_REFUND_TIME = 1110009
      CANNOT_DELETE = 1110010
      LIMIT_PAY = 1110011
      REBUY = 1110012
      OUTDATE = 1110013
      DEDUCTION_ERROR = 1110014
    end

    module Account
      NO_CERTIFICATION = 1100051
      ALREADY_CERTIFICATION = 1100052
      CERT_NO_FORMAT_WRONG = 1100053
      REAL_NAME_FORMAT_WRONG = 1100054
      CERT_NO_ALREADY_EXIST = 1100055
      NO_CHANGE_PERMISSION = 1100056
      CERT_TYPE_INVALID = 1100057
      INVALID_OPTION = 1100058
      CANNOT_UPDATE = 1100059
      SINGLE_CERTIFICATION = 1100060
      CANNOT_UPDATE_CERT_TYPE = 1100061
      CERT_NO_TWICE = 1100062
      USER_SILENCED = 1100063
      USER_BLOCKED = 1100064
    end

    module File
      FORMAT_WRONG = 1200001
      SIZE_TOO_LARGE = 1200002
      CREATE_DIR_FAILED = 1200003
      UPLOAD_FAILED = 1200004
    end

    module Auth
      AUTH_ERROR = 1300001
      ALREADY_BIND = 1300002
    end

    module Comment
      BODY_BLANK = 1400001
      ILLEGAL_KEYWORDS = 1400002
      CANNOT_DELETE = 1400003
    end
  end

  ERROR_MESSAGES = {
    Error::Http::SUCCESS_CALL => 'OK',

    Error::Http::HTTP_NO_CREDENTIAL => '请求缺少身份信息',
    Error::Http::HTTP_INVALID_CREDENTIAL => '无效的请求身份',
    Error::Http::HTTP_CREDENTIAL_NOT_MATCH => '请求身份不匹配',
    Error::Http::HTTP_TOKEN_EXPIRED => 'access token已失效',
    Error::Http::HTTP_LOGIN_REQUIRED => '需要登录后才可以操作',
    Error::Http::HTTP_ACCESS_FORBIDDEN => '无权访问',
    Error::Http::HTTP_USER_BAN => '该用户已封禁,无法进行该操作',

    Error::Common::MISSING_PARAMETER => '缺少参数',
    Error::Common::PARAM_FORMAT_ERROR => '参数格式错误',
    Error::Common::DATE_FORMAT_ERROR => '日期格式错误',
    Error::Common::UNSUPPORTED_TYPE => '不支持的类型',
    Error::Common::DATABASE_ERROR => '数据库错误',
    Error::Common::NOT_FOUND => '找不到指定记录',
    Error::Common::SYSTEM_ERROR => '系统错误',
    Error::Common::PARAM_VALUE_NOT_ALLOWED => '参数值不在允许范围内',
    Error::Common::ERROR_NOTICE => '操作有误',
    Error::Sign::EMAIL_FORMAT_WRONG => '无效的邮箱格式',
    Error::Sign::MOBILE_FORMAT_WRONG => '无效的手机号码',
    Error::Sign::MOBILE_ALREADY_USED => '手机号码已被使用',
    Error::Sign::EMAIL_ALREADY_USED => '邮箱已被使用',
    Error::Sign::PASSWORD_FORMAT_WRONG => '密码格式不正确',
    Error::Sign::USER_NOT_FOUND => '用户不存在',
    Error::Sign::USER_ALREADY_EXIST => '用户已存在',
    Error::Sign::PASSWORD_NOT_MATCH => '用户密码不匹配',
    Error::Sign::VCODE_NOT_MATCH => '验证码不匹配',
    Error::Sign::VCODE_TYPE_WRONG => '验证码类型不匹配',
    Error::Sign::UNSUPPORTED_RESET_TYPE => '不支持的重置类型 ',
    Error::Sign::UNSUPPORTED_OPTION_TYPE => '不支持的操作类型 ',
    Error::Sign::ACCOUNT_ALREADY_BIND => '该账户已被绑定',

    Error::File::FORMAT_WRONG => '文件格式有误',
    Error::File::SIZE_TOO_LARGE => '文件大小超过限制',
    Error::File::CREATE_DIR_FAILED => '创建目录失败',
    Error::File::UPLOAD_FAILED => '文件上传失败',

    Error::Race::TICKET_NO_SELL => '该赛事没有售票功能',
    Error::Race::TICKET_SOLD_OUT => '票已卖完',
    Error::Race::TICKET_END => '售票已结束',
    Error::Race::TICKET_UNSOLD => '售票还没开始',
    Error::Race::AGAIN_BUY => '您已购买过该票，不允许再次购买',
    Error::Race::E_TICKET_SOLD_OUT => '电子票已售完',
    Error::Race::ENTITY_TICKET_SOLD_OUT => '实体票已售完',

    Error::Order::CANNOT_CANCEL => '当前状态不允许取消订单',
    Error::Order::CANNOT_PAY => '当前状态不能支付',
    Error::Order::PAY_ERROR => '支付不成功',
    Error::Order::INVITE_CODE_NOT_EXIST => '邀请码不存在',
    Error::Order::INVALID_ORDER => '无效的订单',
    Error::Order::CANNOT_CONFIRM => '当前状态不允许确认收货',
    Error::Order::SEVEN_DAYS_REFUND_ERROR => '退换列表有商品不支持7天退换货',
    Error::Order::INVALID_REFUND_PRICE => '退款金额不合法或超出实际金额',
    Error::Order::CANNOT_REFUND => '当前商品已退款完成',
    Error::Order::OVER_REFUND_TIME => '订单已经超过售后保障期',
    Error::Order::CANNOT_DELETE => '订单状态不支持删除',
    Error::Order::LIMIT_PAY => '超出购买数量',
    Error::Order::REBUY => '同个用户只能购买一次',
    Error::Order::OUTDATE => '众筹已截止',
    Error::Order::DEDUCTION_ERROR => '可抵扣的扑客币数量异常',

    Error::Account::NO_CERTIFICATION => '用户未实名',
    Error::Account::REAL_NAME_FORMAT_WRONG => '真实姓名格式错误',
    Error::Account::CERT_NO_FORMAT_WRONG => '身份证格式错误',
    Error::Account::CERT_NO_ALREADY_EXIST => '该用户已实名',
    Error::Account::NO_CHANGE_PERMISSION => '账号一个自然月只能修改一次',
    Error::Account::CERT_TYPE_INVALID => '证件类型不正确',
    Error::Account::INVALID_OPTION => '非法操作',
    Error::Account::CANNOT_UPDATE => '当前状态不能修改',
    Error::Account::SINGLE_CERTIFICATION => '您已存在该种证件类型的实名审核，不能再次添加',
    Error::Account::CERT_NO_TWICE => '您已提交过该证件的实名信息，不能再次添加',
    Error::Account::CANNOT_UPDATE_CERT_TYPE => '证件类型不可修改',
    Error::Account::USER_SILENCED => '很抱歉，您已被禁言',
    Error::Account::USER_BLOCKED => '很抱歉，您已被系统管理员拉入黑名单',

    Error::Auth::AUTH_ERROR => '微信授权失败',
    Error::Auth::ALREADY_BIND => '该微信已绑定过其它账户',

    Error::Comment::BODY_BLANK => '评论或回复的内容不能为空',
    Error::Comment::ILLEGAL_KEYWORDS => '很抱歉，您评论中存在敏感字符',
    Error::Comment::CANNOT_DELETE => '不能删除他人的评论'
  }.freeze
end
