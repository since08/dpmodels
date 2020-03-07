class Reply < ApplicationRecord
  belongs_to :topic, polymorphic: true
  belongs_to :comment
  belongs_to :user
  has_many :dynamics, as: :typological, dependent: :destroy
  has_many :replies, class_name: 'Reply', foreign_key: 'reply_id', dependent: :destroy
  belongs_to :reply, optional: true
  belongs_to :reply_user, class_name: 'User', primary_key: 'id', foreign_key: 'reply_user_id'
  include Typologicalable
  include UnscopeTopic

  default_scope { where(deleted: false) }

  after_create do
    comment.increment!(:reply_count)
  end

  after_destroy do
    comment.decrement!(:reply_count)
  end

  def admin_delete(reason = '')
    update(deleted_reason: reason, deleted_at: Time.zone.now, deleted: true)
    Dynamic.create(user: User.official, typological: self, option_type: 'delete')
  end

  def self.user_replies(user)
    where(reply_user: user).order(created_at: :desc)
  end

  def self.read!(user)
    where(reply_user: user).where(is_read: false).update(is_read: true)
  end

  def self.unread_count(user)
    where(reply_user: user).where(is_read: false).count
  end
end
