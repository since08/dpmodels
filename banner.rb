class Banner < ApplicationRecord
  include Publishable

  mount_uploader :image, BannerUploader
  attr_accessor :source_title

  validates :source_type, presence: true
  validates :source_id, presence: true, if: :internal_source?
  validates :image, presence: true, if: :new_record?

  enum banner_type: { homepage: 'homepage', crowdfunding: 'crowdfunding' }

  scope :default_order, -> { order(position: :asc) }
  scope :published, -> { where(published: true) }
  scope :homepage_published, -> { homepage.published }
  scope :crowdfunding_published, -> { crowdfunding.published }

  def internal_source?
    source_type.in? %w(race info video)
  end

  def source
    @source ||= source_id && source_type.classify.safe_constantize.find(source_id)
  end

  def source_title
    return if source.nil?

    source[:name] || source[:title]
  end
end
