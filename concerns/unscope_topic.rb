module UnscopeTopic
  extend ActiveSupport::Concern

  def unscoped_topic
    topic_type.constantize.unscoped.find_by(id: topic_id)
  end
end
