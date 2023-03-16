require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when lead come from myHonda' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.product = product
      lead.description = ''

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

    context 'when description do not contains dealership code' do
      it 'returns original source' do
        expect(switch_source).to eq('myHonda')
      end
    end

    context 'when description contains code 1709446' do
      before { lead.description = 'Concessionária: HIT ILHA - Código: 1709446' }

      it 'returns Ilha in source' do
        expect(switch_source).to eq('myHonda - Ilha')
      end
    end

    context 'when description contains code 1699751' do
      before { lead.description = 'Concessionária: HIT ILHA - Código: 1699751' }

      it 'returns Ilha in source' do
        expect(switch_source).to eq('myHonda - SJ')
      end
    end

    context 'when description contains code 1699751 and Tipo Consórcio' do
      before { lead.description = 'Concessionária: HIT ILHA - Código: 1699751 - Tipo: Consórcio' }

      it 'returns Ilha in source' do
        expect(switch_source).to eq('myHonda - SJ - Consórcio')
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
