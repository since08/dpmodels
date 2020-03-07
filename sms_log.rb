# +--------------+--------------+------+-----+--------------------------------------------------+----------------+
# | Field        | Type         | Null | Key | Default                                          | Extra          |
# +--------------+--------------+------+-----+--------------------------------------------------+----------------+
# | id           | int(11)      | NO   | PRI | NULL                                             | auto_increment |
# | sid          | varchar(255) | YES  |     | NULL                                             |                |
# | mobile       | varchar(255) | YES  |     | NULL                                             |                |
# | content      | varchar(255) | YES  |     | NULL                                             |                |
# | status       | varchar(255) | YES  |     | 发送中-sending, 成功-success, 失败-failed        |                |
# | error_msg    | varchar(255) | YES  |     | NULL                                             |                |
# | fee          | int(11)      | YES  |     | 0                                                |                |
# | send_time    | datetime     | YES  |     | NULL                                             |                |
# | arrival_time | datetime     | YES  |     | NULL                                             |                |
# | created_at   | datetime     | NO   |     | NULL                                             |                |
# | updated_at   | datetime     | NO   |     | NULL                                             |                |
# +--------------+--------------+------+-----+--------------------------------------------------+----------------+
class SmsLog < ApplicationRecord
end
