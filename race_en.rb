class RaceEn < ApplicationRecord
  mount_uploader :logo, RacePhotoUploader
  belongs_to :race, foreign_key: :id

  before_save do
    diff_attrs = %w(name prize location ticket_price blind updated_at)
    attrs = race.reload.attributes.reject { |k| attributes[k].present? && k.in?(diff_attrs) }
    attrs.delete('logo')
    assign_attributes attrs
  end

  enum status: [:unbegin, :go_ahead, :ended, :closed]

  def preview_logo
    return '' if logo.url.nil?

    logo.url(:sm)
  end
end
