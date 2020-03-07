class Dynamic < ApplicationRecord
  belongs_to :typological, polymorphic: true
  belongs_to :user

  def self.received_message
    where.not(typological_type: 'TopicLike')
  end

  def self.normal_dynamics
    where(option_type: 'normal')
  end

  def deleted_type?
    option_type.eql?('delete')
  end

  def unscoped_typological
    typological_type.constantize.unscoped.find_by(id: typological_id)
  end

  def unscoped_typological_topic
    unscoped_typological&.unscoped_topic
  end
end
