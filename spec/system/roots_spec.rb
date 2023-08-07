# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Roots', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'トップページを表示する' do
    visit root_path
    expect(page).to have_content 'Circle Cast'
  end
end
