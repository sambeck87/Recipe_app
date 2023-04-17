require 'rails_helper'

RSpec.describe 'foods/index', type: :view do
  before(:each) do
    assign(:foods, [
             Food.create!(
               name: 'Name',
               measurement_unit: 'Measurement Unit',
               price: '9.99',
               quantity: 2,
               user: nil
             ),
             Food.create!(
               name: 'Name',
               measurement_unit: 'Measurement Unit',
               price: '9.99',
               quantity: 2,
               user: nil
             )
           ])
  end

  it 'renders a list of foods' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Measurement Unit'.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
  end
end
