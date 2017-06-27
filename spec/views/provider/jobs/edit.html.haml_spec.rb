require 'spec_helper'

describe 'provider/jobs/edit.html.haml' do

  let(:provider) { Fabricate(:provider, firstname: 'Chuck', lastname: 'Norris') }
  let(:job) { Fabricate(:job, provider: provider) }

  before do
    assign(:job, job)
    render
  end

  context 'form elements' do
    it 'renders the job inputs' do
      expect(rendered).to have_field('Arbeitskategorie', with: job.work_category.id)
      expect(rendered).to have_field('Titel', with: job.title)
      expect(rendered).to have_field('Beschreibung', with: job.short_description)
    end

    it 'renders the date inputs' do
      expect(rendered).to have_field('Zeitraum', with: job.date_type)

      expect(rendered).to have_field('job_start_date_3i', with: job.start_date.day)
      expect(rendered).to have_field('job_start_date_2i', with: job.start_date.month)
      expect(rendered).to have_field('job_start_date_1i', with: job.start_date.year)

      expect(rendered).to have_field('job_end_date_3i', with: job.end_date.day)
      expect(rendered).to have_field('job_end_date_2i', with: job.end_date.month)
      expect(rendered).to have_field('job_end_date_1i', with: job.end_date.year)
    end

    it 'renders the salary inputs' do
      expect(rendered).to have_field('Art des Lohnes', with: job.salary_type)
      expect(rendered).to have_field('Lohn', with: job.salary)
    end

    it 'renders the work inputs' do
      expect(rendered).to have_field('Arbeitskräfte', with: job.manpower)
      expect(rendered).to have_field('Dauer', with: job.duration)
    end

    context 'form actions' do
      it 'renders the update button' do
        expect(rendered).to have_button('Bearbeiten')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to show the job' do
      expect(rendered).to have_link('Anzeigen', provider_job_path(job))
    end

    it 'contains the link to the job list' do
      expect(rendered).to have_link('Zurück', provider_jobs_path)
    end
  end
end
