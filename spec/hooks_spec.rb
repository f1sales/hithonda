require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when lead come from myHonda' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.message = nil

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = 'myHonda'

      source
    end

    let(:switch_source) { described_class.switch_source(lead) }

    context 'when message do not contains dealership code' do
      it 'returns original source' do
        expect(switch_source).to eq('myHonda')
      end
    end

    context 'when message contains code 1709446' do
      before { lead.message = 'Código da concessionária 1709446'}

      it 'returns Ilha in source' do
        expect(switch_source).to eq('myHonda - Ilha')
      end
    end

    context 'when message contains code 1699751' do
      before { lead.message = 'Código da concessionária 1699751'}

      it 'returns Ilha in source' do
        expect(switch_source).to eq('myHonda - SJ')
      end
    end
  end
end
