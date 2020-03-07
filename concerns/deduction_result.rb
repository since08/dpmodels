module DeductionResult
  extend ActiveSupport::Concern

  def deduction_success
    update(deduction_result: 'success')
  end

  def deduction_failed
    update(deduction_result: 'failed')
  end
end
