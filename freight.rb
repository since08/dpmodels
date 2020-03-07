class Freight < ApplicationRecord
  has_many :fre_specials
  has_many :fre_special_provinces, through: :fre_specials

  def find_province_freight(province)
    fre_special_provinces.find_by(province_name: province)&.fre_special || self
  end

  def default!
    update(default: true)
  end

  def no_default!
    update(default: false)
  end

  # 获取商品的运费
  def product_freight(destination, options = {})
    params = {
      weight: options.delete(:weight) || 1,
      number: options.delete(:number) || 1,
      volume: options.delete(:volume) || 1
    }
    condition = calculate_condition(params)
    calculate(find_province_freight(destination), condition)
  end

  def calculate_condition(params)
    case freight_type
    when 'number'
      params[:number]
    when 'weight'
      params[:number] * params[:weight]
    when 'volume'
      params[:number] * params[:volume]
    end
  end

  def calculate(spe_freight, condition)
    diff = condition - spe_freight.first_cond
    return spe_freight.first_price if diff <= 0
    spe_freight.first_price + (diff / spe_freight.add_cond).ceil * spe_freight.add_price
  end
end
