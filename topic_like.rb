class TopicLike < ApplicationRecord
  belongs_to :topic, polymorphic: true
  belongs_to :user
  has_many :dynamics, as: :typological, dependent: :destroy
  include Typologicalable
  include UnscopeTopic
end
