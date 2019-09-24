module JobsCertificateHelper
  # Show default text to JobsCertificate
  #
  # @param seeker [Seeker]
  # @param organization [Organization]
  #
  # @return [html] default certificate html format
  #
  def certificate_for_editor(seeker, organization)
    @content = "#{seeker.firstname} #{seeker.lastname} geboren #{seeker.date_of_birth.strftime('%d.%m.%Y')} von #{seeker.place.name} arbeitet seit
                #{seeker.created_at.strftime('%d.%m.%Y')} im Rahmen der Taschengeld-Vermittlungs-Börse von #{organization.name}.
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
      provider_jobs[provider.id] = {}

      jobs = seeker.jobs.where(provider_id: provider.id).order(:start_date)
      jobs_last_end_date = seeker.jobs.where(provider_id: provider.id).order(end_date: :asc).limit(1).first
      provider_jobs[provider.id][:jobs] = jobs
      provider_jobs[provider.id][:jobs_start] = jobs.first.start_date
      provider_jobs[provider.id][:jobs_end] = jobs_last_end_date.end_date
      provider_jobs[provider.id][:assignment_count] = seeker.assignments.where(job_id: jobs.pluck(:id)).count
      provider_jobs[provider.id][:assignment_duration] = seeker.assignments.where(job_id: jobs.pluck(:id)).sum(:duration)/(60_000*60)
      provider_jobs[provider.id][:company] = provider.company.try(:name)
      provider_jobs[provider.id][:provider] = "#{provider.firstname} #{provider.lastname}"
    end


    content_tag(:table, style: "width: 100%") do
      content_tag(:tr, style: "text-align: left") do
        content_tag(:th, "Datum")+
        content_tag(:th, "Anzahl Einsätze:")+
        content_tag(:th, "Dauer")+
        content_tag(:th, "Arbeitgebende")+
        content_tag(:th, "Tätigkeit")
      end+
      provider_jobs.map do |_, provider_job|
        content_tag(:tr) do
          content_tag(:td, "#{provider_job[:jobs_start]} #{"-" if provider_job[:jobs_start].present? and provider_job[:jobs_end].present?} #{provider_job[:jobs_end]}")+
          content_tag(:td, "#{provider_job[:assignment_count]}x")+
          content_tag(:td, "#{provider_job[:assignment_duration]}")+
          content_tag(:td, "#{provider_job[:company]} #{"<br>" if provider_job[:company].present? and provider_job[:provider].present?}  #{provider_job[:provider]}".html_safe)+
          content_tag(:td) do
            provider_job[:jobs].map do |job|
              content_tag(:div) do
                content_tag(:strong, job.title)+
                content_tag(:br)+
                content_tag(:span, job.allocations.where(seeker_id: seeker.id).map{|allocation| allocation.feedback_provider}.join("<br>").html_safe)
              end.html_safe
            end.join("").html_safe
          end
        end
      end.join("").html_safe

    end.html_safe



  end

end