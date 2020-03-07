##
# 票数计数器
#
module TicketNumberCounter
  extend ActiveSupport::Concern

  def return_a_e_ticket
    ticket_info.decrement!(:e_ticket_sold_number)
    update(status: 'selling') if status == 'sold_out'
  end

  def return_a_entity_ticket
    ticket_info.decrement!(:entity_ticket_sold_number)
    update(status: 'selling') if status == 'sold_out'
  end
end
