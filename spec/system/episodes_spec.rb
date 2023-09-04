# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Episodes', type: :system do
  fixtures :all

  describe '管理者の場合' do
    before do
      sign_in users(:nakajima)
    end

    it 'エピソードを作成すること' do
      visit channel_path(channels(:group2_ch1))
      click_on 'エピソードを作成'
      fill_in 'タイトル', with: '新しいエピソードのタイトル！'
      fill_in '説明', with: '新しいエピソードの説明です。新しいエピソードの説明その2です。'
      attach_file '音声ファイル', 'spec/fixtures/files/audio1.m4a'
      click_on '登録する'

      expect(page).to have_content 'エピソードを作成しました'
      expect(page).to have_content '新しいエピソードのタイトル！'
      expect(page).to have_content '新しいエピソードの説明です。'
    end

    it 'エピソードを削除すること' do
      visit channel_episode_path(channels(:nbc_channel2), episodes(:nbc_episode21))
      accept_confirm { click_on '削除' }

      expect(page).to have_content 'エピソードを削除しました'
      expect(page).not_to have_content 'ep.1 2月2日'
    end
  end

  describe 'メンバーの場合' do
    before do
      sign_in users(:nbc_student1)
    end

    it 'エピソードを表示すること' do
      visit channel_path(channels(:nbc_channel2))
      click_on 'ep.1 2月2日'

      expect(page).to have_content 'ep.1 2月2日'
      expect(page).to have_content '必聴です'
      audio = all('audio')
      expect(audio.size).to eq 1
    end
  end
end
