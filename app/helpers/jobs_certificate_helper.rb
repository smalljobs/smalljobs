module JobsCertificateHelper
  # Show default text to JobsCertificate
  #
  # @param seeker [Seeker]
  # @param organization [Organization]
  #
  # @return [html] default certificate html format
  #
  def certificate_for_editor(seeker, organization)
    @content = "#{seeker.firstname} #{seeker.lastname}, geboren #{seeker.date_of_birth_format} von #{seeker.place.name}, arbeitet seit
                #{seeker.created_at.strftime('%d.%m.%Y')} im Rahmen der Taschengeld-Vermittlungs-Börse von #{organization&.name}.
                <br/>
                <br/>
                #{seeker.firstname} #{seeker.lastname} hat in dieser Zeit bei #{seeker.providers.count} Arbeitgebenden
                #{seeker.assignments.count} Einsätze geleistet und insgesamt  #{seeker.assignments.sum(:duration) / (60_000*60)}
                Stunden gearbeitet.
                <br/>
                <br/>
                <br/>
                #{jobs_table(seeker)}
                <br/>
                <br/>
                Wir danken #{seeker.firstname} für die Arbeit und Wünschen für die Zukunft alles Gute."


  end


  # Show default table to JobsCertificate content for on seeker
  #
  # @param seeker [Seeker]
  #
  # @return [html] default certificate table, html format
  #
  def jobs_table(seeker)
    provider_jobs = {}
    seeker.providers.each do |provider|
      jobs = seeker.jobs.where(provider_id: provider.id).includes(:allocations).
          where("allocations.seeker_id = ?", seeker.id).where.not("allocations.state": [:application_rejected, :cancelled]).
          order(:start_date)
      jobs_last_end_date = seeker.jobs.where(provider_id: provider.id).includes(:allocations).
          where("allocations.seeker_id = ?", seeker.id).where.not("allocations.state": [:application_rejected, :cancelled]).
          order(end_date: :asc).limit(1).first

      if jobs.present? and jobs.first.assignments.exists? and jobs.first.assignments.first.start_time.present?
        start_date = jobs.first.assignments.order(:start_time).first.start_time.to_date.strftime("%d.%m.%Y")
      elsif jobs.present?  and jobs.first.start_date.present?
        start_date = jobs.first.start_date.strftime("%d.%m.%Y")
      elsif jobs.present?
        start_date = jobs.first.created_at.strftime("%d.%m.%Y")
      else
        start_date = nil
      end

      if jobs_last_end_date.present? and jobs_last_end_date.assignments.exists? and jobs_last_end_date.assignments.first.end_time.present?
        end_date = jobs_last_end_date.assignments.order(end_time: :desc).first.end_time.to_date.strftime("%d.%m.%Y")
      elsif jobs_last_end_date.present?  and jobs_last_end_date.end_date.present?
        end_date = jobs_last_end_date.end_date.strftime("%d.%m.%Y")
      else
        end_date = nil
      end

      if jobs.present?
        provider_jobs[provider.id] = {}
        provider_jobs[provider.id][:jobs] = jobs
        provider_jobs[provider.id][:jobs_start] = start_date
        provider_jobs[provider.id][:jobs_end] = end_date
        provider_jobs[provider.id][:assignment_count] = seeker.assignments.where(job_id: jobs.pluck(:id)).count
        provider_jobs[provider.id][:assignment_duration] = seeker.assignments.where(job_id: jobs.pluck(:id)).sum(:duration)/(60_000*60)
        provider_jobs[provider.id][:company] = provider.company
        provider_jobs[provider.id][:provider] = "#{provider.firstname} #{provider.lastname}"
      end
    end


    content_tag(:table, class:"green-table", style: "width: 100%, border-collapse:collapse;", border: "1", cellpadding: "0",  cellspacing: "0", bordercolor: "#cbe7d5" ) do
      content_tag(:thead) do
        content_tag(:tr, style: "text-align: left") do
          content_tag(:th, "Datum")+
          content_tag(:th, "Anzahl Einsätze")+
          content_tag(:th, "Dauer")+
          content_tag(:th, "Arbeitgebende")+
          content_tag(:th, "Tätigkeit")
        end
      end+
      content_tag(:tbody) do
      provider_jobs.map do |_, provider_job|
        content_tag(:tr) do
          content_tag(:td) do
            content_tag(:div,"#{provider_job[:jobs_start]} #{"-".html_safe if provider_job[:jobs_start].present? and provider_job[:jobs_end].present?} #{provider_job[:jobs_end]}".html_safe, style: "white-space: nowrap;")
          end+
          content_tag(:td, "#{provider_job[:assignment_count]}x")+
          content_tag(:td, "#{provider_job[:assignment_duration]}h")+
          content_tag(:td, "#{provider_job[:company]} #{"<br>" if provider_job[:company].present? and provider_job[:provider].present?}  #{provider_job[:provider]}".html_safe)+
          content_tag(:td) do
            provider_job[:jobs].map do |job|
              content_tag(:div) do
                content_tag(:div, job.title)+
                content_tag(:span, job.allocations.where(seeker_id: seeker.id).where.not(state: [:application_rejected, :cancelled]).map{|allocation| allocation.feedback_seeker.present? ? allocation.feedback_seeker : nil }.compact.join("<br>").html_safe)
              end.html_safe
            end.join("<br>").html_safe
          end
        end
      end.join("").html_safe
     end
    end.html_safe



  end

end
