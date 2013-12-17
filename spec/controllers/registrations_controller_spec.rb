require 'spec_helper'

describe RegistrationsController do

  describe '#after_inactive_sign_up_path_for' do
    [:job_seeker, :job_provider, :job_broker].each do |type|
      context "for a #{ type}" do
        it 'returns the awaiting confirmation path when unconfirmed' do
          user = Fabricate(type, confirmed: false, active: false)
          expect(controller.after_inactive_sign_up_path_for(user)).to eq('/awaiting_confirmation')
        end

        it 'returns the awaiting activation path when inactive' do
          user = Fabricate(type, confirmed: true, active: false)
          expect(controller.after_inactive_sign_up_path_for(user)).to eq('/awaiting_activation')
        end
      end
    end
  end

end
