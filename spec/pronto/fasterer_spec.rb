require 'spec_helper'

module Pronto
  describe Fasterer do
    let(:fasterer) { Fasterer.new(patches) }

    describe '#run' do
      subject { fasterer.run }

      context 'patches are nil' do
        let(:patches) { nil }
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end
    end
  end
end
