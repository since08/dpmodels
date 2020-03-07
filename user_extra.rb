# +------------+--------------+------+-----+------------+----------------+
# | Field      | Type         | Null | Key | Default    | Extra          |
# +------------+--------------+------+-----+------------+----------------+
# | id         | int(11)      | NO   | PRI | NULL       | auto_increment |
# | user_id    | int(11)      | YES  | MUL | NULL       |                |
# | real_name  | varchar(50)  | YES  |     | NULL       |                |
# | cert_type  | varchar(50)  | YES  |     | chinese_id |                |
# | cert_no    | varchar(255) | YES  |     | NULL       |                |
# | memo       | varchar(255) | YES  |     | NULL       |                |
# | image      | varchar(255) | YES  |     |            |                |
# | image_md5  | varchar(32)  | NO   |     |            |                |
# | status     | varchar(20)  | YES  |     | pending    |                |
# | created_at | datetime     | NO   |     | NULL       |                |
# | updated_at | datetime     | NO   |     | NULL       |                |
# +------------+--------------+------+-----+------------+----------------+
# 用户认证信息表
class UserExtra < ApplicationRecord
  belongs_to :user, optional: true
  mount_uploader :image, CardImageUploader

  enum status: { init: 'init', pending: 'pending', 'passed': 'passed', 'failed': 'failed' }
  attr_accessor :image_path

  # 过滤掉已删除掉实名认证
  # default_scope { where(is_delete: 0) } unless ENV['CURRENT_PROJECT'] == 'dpcms'

  validates :real_name, :cert_no, presence: true, if: -> { ENV['CURRENT_PROJECT'].eql?('dpcms') }

  after_update do
    Notification.notify_certification(self) if status_changed? && after_check_status?
  end

  def after_check_status?
    status.in? %w(passed failed)
  end

  def image=(value)
    super
    # rubocop:disable Style/GuardClause:27
    if image.file.present? && image.file.respond_to?(:path) && File.exist?(image.file.path)
      self.image_md5 = Digest::MD5.file(image.file.path).hexdigest
    end
  end

  def image_path
    return '' if image.url.nil?

    image.url
  end
end