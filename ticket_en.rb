class TicketEn < ApplicationRecord
  mount_uploader :logo, TicketUploader
  mount_uploader :banner, TicketUploader
  belongs_to :ticket, foreign_key: :id

  before_save do
    self.description = ActionController::Base.helpers.strip_tags(description)
    diff_attrs = %w(title description updated_at)
    attrs = ticket.reload.attributes.reject { |k| attributes[k].present? && k.in?(diff_attrs) }
    assign_attributes attrs.reject { |k| k.in?(%w(logo banner)) }
  end

  def preview_logo
    return '' if logo.url.nil?

    logo.url(:sm)
  end

  def preview_banner
    return '' if banner.url.nil?

    banner.url(:sm)
  end
end
