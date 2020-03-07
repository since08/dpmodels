module Typologicalable
  extend ActiveSupport::Concern
  included do
    after_create :create_dynamic
  end

  def create_dynamic
    dynamics.create(user: user)
  end
end
