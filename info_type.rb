class InfoType < ApplicationRecord
  include Publishable

  has_many :infos, dependent: :destroy
  has_one :info_type_en, foreign_key: 'id', dependent: :destroy
  accepts_nested_attributes_for :info_type_en, update_only: true

  after_update do
    info_type_en || build_info_type_en
    info_type_en.save
  end

  default_scope { where(published: true) } unless ENV['CURRENT_PROJECT'] == 'dpcms'
end
