# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def space_correction_english
    english.gsub!(/\s{2,}/, ' ')
    english.gsub!(/\s+/, '') if english.match(/\s+\z/)
  end

  def correction_japanese
    japanese.gsub!(/[ー]+/, 'ー')
  end
end
