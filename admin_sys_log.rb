class AdminSysLog < ApplicationRecord
  belongs_to :operation, polymorphic: true
  belongs_to :admin_user
end
