# frozen_string_literal: true

RSpec.describe Task, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:done).of_type(:boolean) }
    it { is_expected.to have_db_column(:deadline).of_type(:datetime) }
    it { is_expected.to have_db_column(:comments_count).of_type(:integer) }
    it { is_expected.to have_db_column(:project_id).of_type(:integer) }
  end

  context 'relations' do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to belong_to(:project) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:position).only_integer }
  end
end
