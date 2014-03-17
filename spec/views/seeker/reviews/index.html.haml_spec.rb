require 'spec_helper'

describe 'seeker/reviews/index.html.haml' do

  let(:job) { Fabricate(:job, title: 'Job A') }

  let(:review_A) { Fabricate(:review, job: job, message: 'Try this', seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'A')) }
  let(:review_B) { Fabricate(:review, job: job, message: 'Another one', provider: Fabricate(:provider, firstname: 'Provider', lastname: 'B')) }

  context 'with reviews' do
    before do
      assign(:job, job)
      assign(:reviews, [review_A, review_B])
      render
    end

    context 'list items' do
      it 'render the job title' do
        expect(rendered).to have_text('Job A')
      end

      it 'render the review message name' do
        expect(rendered).to have_text('Try this')
        expect(rendered).to have_text('Another one')
      end

      it 'render the rated seeker name' do
        expect(rendered).to have_text('Seeker A')
      end

      it 'render the rated provider name' do
        expect(rendered).to have_text('Provider B')
      end

      context 'list item data' do
        it 'contains the link to edit the reviews details' do
          expect(rendered).to have_link('Seeker A Job A bearbeiten', href: edit_seeker_job_review_path(job, review_A))
          expect(rendered).to have_link('Provider B Job A bearbeiten', href: edit_seeker_job_review_path(job, review_B))
        end

        it 'contains the link to destroy the review' do
          expect(rendered).to have_link('Seeker A Job A löschen', href: seeker_job_review_path(job, review_A))
          expect(rendered).to have_link('Provider B Job A löschen', href: seeker_job_review_path(job, review_B))
        end
      end
    end
  end

  context 'without reviews' do
    before do
      assign(:job, job)
      assign(:reviews, [])
      render
    end

    it 'shows a message that no reviews are found' do
      expect(rendered).to have_text('Es sind noch keine Bewertungen für diesen Job erfasst')
    end
  end

  context 'global actions' do
    before do
      assign(:job, job)
      assign(:reviews, [])
      render
    end

    it 'contains the link to add a new review' do
      expect(rendered).to have_link('Neue Bewertung hinzufügen', new_seeker_job_review_path(job))
    end

    it 'contains the link to go back to the job' do
      expect(rendered).to have_link('Zurück', seeker_job_path(job))
    end
  end
end
