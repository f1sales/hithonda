require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when lead come from myHonda' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.product = product
      lead.message = 'Código da concessionária 1709446'

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = 'myHonda'

      source
    end

    let(:product) do
      product = OpenStruct.new
      product.name = ''

      product
    end

    let(:switch_source) { described_class.switch_source(lead) }

    context 'when message do not contains dealership code' do
      before { lead.message = nil }

      it 'returns original source' do
        expect(switch_source).to eq('myHonda')
      end
    end

    context 'when message contains code 1709446' do
      it 'returns Ilha in source' do
        expect(switch_source).to eq('myHonda - Ilha')
      end
    end

    context 'when message contains code 1699751' do
      before { lead.message = 'Código da concessionária 1699751' }

      it 'returns Ilha in source' do
        expect(switch_source).to eq('myHonda - SJ')
      end
    end

    context 'when product is revisão' do
      before { product.name = 'WRV - Revisão' }

      it 'returns Fonte sem time' do
        expect(switch_source).to eq('myHonda - Revisão')
      end
    end
  end
end
