shared_examples_for 'a confirm toggle' do

  describe '#confirmed=' do
    context 'when not confirmed' do
      let(:provider) { Fabricate(:provider, confirmed: false) }

      it 'confirms the user when set to 1' do
        expect(provider.confirmed?).to be_false
        provider.confirmed = 1
        expect(provider.confirmed?).to be_true
      end
    end

    context 'when already confirmed' do
      let(:provider) { Fabricate(:provider, confirmed: true) }

      it 'unconfirms the user when set to 0' do
        expect(provider.confirmed?).to be_true
        provider.confirmed = 0
        expect(provider.confirmed?).to be_false
      end
    end
  end

end
