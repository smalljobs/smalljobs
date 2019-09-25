module SeekerHelper


  def allocations_with_numbers(seeker)
    allocations_group = seeker.allocations.order(:state).group(:state).count
    allocations_group.map do |k,v|
      if v > 0
        link_to "#{v} #{I18n.t("activerecord.attributes.allocation.state_label.#{k}")}", "##{k}"
      end
    end.compact.join(", ").html_safe
  end

  def total_amount_earned_in_assignment(seeker)
    assignments = seeker.assignments
    "#{assignments.count} Einsätze, Total verdient: CHF #{assignments.sum(:payment)}"
  end
end
