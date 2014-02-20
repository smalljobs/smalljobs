require 'spec_helper'

describe 'broker/jobs/show.html.haml' do

  let(:region) { Fabricate(:region) }
  let(:work_category) { Fabricate(:work_category, name: 'Botengang') }
  let(:provider) { Fabricate(:provider, place: region.places.first) }
  let(:job) { Fabricate(:job, provider: provider, work_category: work_category) }

  before do
    assign(:job, job)
    view.stub(current_region: region)
    render
  end

  context 'the job' do
    it 'shows the job title' do
      expect(rendered).to have_text(job.title)
    end

    it 'shows the job description' do
      expect(rendered).to have_text(job.description)
    end

    it 'shows the work category' do
      expect(rendered).to have_text('Botengang')
    end

    context 'with a job date on agreement' do
      let(:job) { Fabricate(:job,
                            date_type: 'agreement',
                            provider: provider) }

      it 'shows that the date is on agreement' do
        expect(rendered).to have_text('Nach Absprache')
      end
    end

    context 'with a job date on date' do
      let(:job) { Fabricate(:job,
                            date_type: 'date',
                            start_date: Date.new(2014, 3, 31),
                            provider: provider) }

      it 'shows that the job is on a specific date' do
        expect(rendered).to have_text('Am 31. März 2014')
      end
    end

    context 'with a job date between two dates' do
      let(:job) { Fabricate(:job,
                            date_type: 'date_range',
                            start_date: Date.new(2014, 3, 31),
                            end_date: Date.new(2014, 4, 30),
                            provider: provider) }

      it 'shows that the job is between two dates' do
        expect(rendered).to have_text('Zwischen dem 31.03.2014 und dem 30.04.2014')
      end
    end

    context 'with a fixed job salary' do
      let(:job) { Fabricate(:job,
                            salary_type: 'fixed',
                            salary: 150,
                            provider: provider) }

      it 'shows that the salary is fixed' do
        expect(rendered).to have_text('Fixer Preis')
      end

      it 'shows the fixed price' do
        expect(rendered).to have_text('CHF 150.00')
      end
    end

    context 'with an hourly job salary' do
      let(:job) { Fabricate(:job,
                            salary_type: 'hourly',
                            salary: 12,
                            provider: provider) }

      it 'shows that the salary is hourly' do
        expect(rendered).to have_text('Stundenlohn')
      end

      it 'shows the hourly price' do
        expect(rendered).to have_text('CHF 12.00')
      end
    end
  end

  context 'the provider' do
    it 'shows the provider name' do
      expect(rendered).to have_text(provider.name)
    end

    it 'shows the provider street' do
      expect(rendered).to have_text(provider.street)
    end

    it 'shows the provider zip' do
      expect(rendered).to have_text(provider.place.zip)
    end

    it 'shows the provider city' do
      expect(rendered).to have_text(provider.place.name)
    end
  end

  context 'the seekers' do
    let(:job) { Fabricate(:job,
                          manpower: 2,
                          duration: 62,
                          provider: provider) }

    it 'shows the needed manpower' do
      expect(rendered).to have_text('Benötigte Arbeitskräfte: 2')
    end

    it 'shows the expected duration' do
      expect(rendered).to have_text('Ungefähre Dauer: 62 Minuten')
    end

    context 'without seekers' do
      it 'shows that the job is unassigned' do
        expect(rendered).to have_text('Noch keine Jugendlichen zugewiesen')
      end
    end

    context 'with allocated seekers' do
      let(:seeker_a) { Fabricate(:seeker, firstname: 'Robert', lastname: 'Buholzer') }
      let(:seeker_b) { Fabricate(:seeker, firstname: 'Susi', lastname: 'Strolch') }

      let(:job) { Fabricate(:job,
                            allocations: [seeker_a, seeker_b],
                            provider: provider) }

      it 'shows and links the assigned seekers' do
        expect(rendered).to have_text('Zugewiesene Jugendliche')
        expect(rendered).to have_link('Robert Buholzer', edit_broker_seeker_path(seeker_a))
        expect(rendered).to have_link('Susi Strolch', edit_broker_seeker_path(seeker_b))
      end
    end
  end

  context 'job process actions' do
    it 'contains the link to list the job proposals' do
      expect(rendered).to have_link('Vorschläge', broker_job_proposals_path(job))
    end

    it 'contains the link to list the job applications' do
      expect(rendered).to have_link('Bewerbungen', broker_job_applications_path(job))
    end

    it 'contains the link to list the job proposals' do
      expect(rendered).to have_link('Zuweisungen', broker_job_allocations_path(job))
    end

    it 'contains the link to list the job proposals' do
      expect(rendered).to have_link('Bewertungen', broker_job_reviews_path(job))
    end
  end

  context 'global actions' do
    it 'contains the link to edit the job' do
      expect(rendered).to have_link('Bearbeiten', edit_broker_job_path(job))
    end

    it 'contains the link to the jobs list' do
      expect(rendered).to have_link('Zurück', broker_jobs_path)
    end
  end
end
