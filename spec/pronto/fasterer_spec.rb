require 'spec_helper'

module Pronto
  describe Fasterer do
    let(:fasterer) { Fasterer.new }

    describe '#run' do
      subject { fasterer.run(patches, nil) }

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
