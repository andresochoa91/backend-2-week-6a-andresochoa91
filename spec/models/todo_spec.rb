require 'rails_helper'

RSpec.describe Todo, type: :model do
  # Association test
  # ensure Todo model has a 1:m relationship with the Item model
  it { should have_many(:items).dependent(:destroy) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }


  path '/todos' do

    get('list todos') do
      tags 'Todos'
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('create todo') do
      tags 'Todos'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :todo, in: :body, required: true, schema: {
        type: :object,
        required: %i[title created_by],
        properties: {
          title: { type: :string },
          created_by: { type: :string }
        }
      }
      response(201, 'successful') do
        let(:todo) { { title: 'Learn Elm', created_by: '1' } }
        run_test!
      end
    end
  end

  path '/todos/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show todo') do
      tags 'Todos'
      response(200, 'successful') do
        let(:id) { 5 }
        # after do |example|
        #   example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        # end
        run_test!
      end
    end

    put('update todo') do
      tags 'Todos'
      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          content: { type: :string }
        }
      }
      response(204, "successful") do
        let(:id) { 5 }
        run_test!
      end
    end

    delete('delete todo') do
      tags 'Todos'
      response(204, "successful") do
        let(:id) { 5 }
        run_test!
      end
    end
  end


end
