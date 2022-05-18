module SeekerHelper


  def allocations_with_numbers(seeker)
    allocations_group = seeker.allocations.order(:state).group(:state).count

    Allocation::CUSTOM_ORDER_STATE.map do |state|
      if allocations_group[state.to_s].to_i > 0
        link_to "#{allocations_group[state.to_s]} #{I18n.t("activerecord.attributes.allocation.state_label.#{state}")}", "##{state}"
      end
    end.compact.join(", ").html_safe
  end

  def total_amount_earned_in_assignment(seeker)
    assignments = seeker.assignments
    "#{assignments.count} Einsätze, Total verdient: #{currency(assignments)} #{assignments.sum(:payment)}"
  end

  def currency(assignments)
    countries = assignments.map { |a| a.job.region.country }.compact.uniq
    return 'CHF' if countries.blank?
    return 'EUR' if countries.size == 1 && (countries.first.name.downcase == 'Germany' || countries.first.alpha2.downcase == 'de')

    'CHF'
  end

  def order_allocation_by_state(allocations)
    allocations_state = []
    Allocation::CUSTOM_ORDER_STATE.map do |state|
      allocations_state = allocations_state + allocations.where(state: state)
    end
    allocations_state
  end
end
