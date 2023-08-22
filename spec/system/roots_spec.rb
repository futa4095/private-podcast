# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Roots', type: :system do
  it 'トップページを表示すること' do
    visit root_path
    expect(page).to have_content 'Circle Cast'
  end

  it '利用規約を表示すること'
  it 'プライバシーポリシーを表示すること'
end
