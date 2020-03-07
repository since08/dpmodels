class Headline < ApplicationRecord
  include Publishable

  belongs_to :source, polymorphic: true
  attr_accessor :source_title
  validates :source_type, presence: true
  validates :source_id, presence: true

  scope :default_order, -> { order(position: :asc) }
  scope :published, -> { where(published: true) }

  def source_title
    return if source.nil?

    source[:name] || source[:title]
  end
end
