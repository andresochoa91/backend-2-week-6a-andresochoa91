require 'rails_helper'

RSpec.describe Item, type: :model do
  # Association test
  # ensure an item record belongs to a single todo record
  it { should belong_to(:todo) }
  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }


  path '/todos/{todo_id}/items' do

    parameter name: 'todo_id', in: :path, type: :integer, description: 'todo_id'

    get('list items') do
      tags 'Items'
      response(200, 'success') do
        run_test!
      end
    end

    post('create item') do
      tags 'Items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :item, in: :body, required: true, schema: {
        type: :object,
        required: %i[name],
        properties: {
          name: {type: :string},
          done: {type: :boolean}
        }
      }
      response(201, 'success') do
        let(:item) { { name: 'thisitem', done: false } }
        run_test!
      end
    end
  end

  path '/todos/{todo_id}/items/{id}' do
    parameter name: 'todo_id', in: :path, type: :integer, description: 'todo_id'
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show item') do
      tags 'Items'
      response(200,'success') do
        run_test!
      end
    end

    put('update item') do
      tags 'Items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :item, in: :body, required: true, schema: {
        type: :object,
        properties: {
          name: {type: :string},
          done: {type: :boolean}
        }
      }
      response(204,'success') do
        let(:item) { { name: 'changedName'} }
        run_test!
      end
    end

    delete('delete item') do
      tags 'Items'
      response(204,'success') do
        run_test!
      end
    end

  end


end
