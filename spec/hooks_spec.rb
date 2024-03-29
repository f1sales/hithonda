require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do
  describe '.switch_source' do
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
          expect(switch_source).to eq('myHonda - Vendas')
        end
      end

      context 'when description contains code 1709446' do
        before { lead.description = 'Concessionária: HIT ILHA - Código: 1709446' }

        it 'returns Ilha in source' do
          expect(switch_source).to eq('myHonda - Vendas')
        end
      end

      context 'when description contains code 1699751' do
        before { lead.description = 'Concessionária: HIT ILHA - Código: 1699751' }

        it 'returns Ilha in source' do
          expect(switch_source).to eq('myHonda - Vendas')
        end
      end

      context 'when is to Consórcio Team' do
        context 'when description contains code 1699751 and Tipo Consórcio' do
          before { lead.description = 'Concessionária: HIT ILHA - Código: 1699751 - Tipo: Consórcio' }

          it 'returns Ilha in source' do
            expect(switch_source).to eq('myHonda - Consórcio')
          end
        end

        context 'when description contains HSF' do
          before { lead.description = 'Concessionária: HIT ILHA; Código: 1709446; Tipo: HSF' }

          it 'returns Ilha in source' do
            expect(switch_source).to eq('myHonda - Consórcio')
          end
        end
      end

      context 'when is to Serviços Team' do
        context 'when product is revisão' do
          before { product.name = 'WRV - Revisão' }

          it 'returns myHonda - Pós-venda' do
            expect(switch_source).to eq('myHonda - Pós-venda')
          end
        end

        context 'when description contains Serviços e Peças' do
          before { lead.description = 'Concessionária: HIT ILHA; Código: 1709446; Tipo: CS - Serviços e Peças' }

          it 'return myHonda - Pós-venda' do
            expect(switch_source).to eq('myHonda - Pós-venda')
          end
        end
      end
    end

    context 'when lead come from other sources' do
      let(:lead) do
        lead = OpenStruct.new
        lead.source = source
        lead.product = product
        lead.description = ''

        lead
      end

      let(:source) do
        source = OpenStruct.new
        source.name = 'Aother source'

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
          expect(switch_source).to eq('Aother source')
        end
      end
    end
  end
end
