class ReplyTemplate < ApplicationRecord
  validates :type_id, presence: { message: '请先到模版管理新建一个模版类别，再进行此操作！' }
  validates :content, presence: true, uniqueness: true
  belongs_to :template_type, foreign_key: :type_id, optional: true

  def temp_name
    template_type&.name
  end
end
