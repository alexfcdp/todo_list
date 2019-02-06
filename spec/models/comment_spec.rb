# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:commentary).of_type(:text) }
    it { is_expected.to have_db_column(:task_id).of_type(:integer) }
  end

  context 'relations' do
    it { is_expected.to belong_to(:task) }
  end

  context 'validations' do
    it { is_expected.to validate_length_of(:commentary).is_at_least(10).is_at_most(256) }
  end

  context 'Attachment' do
    it 'is valid comment image' do
      subject.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'smile.jpg')), \
                           filename: 'smile.jpg', content_type: 'image/jpg')
      expect(subject.image).to be_attached
    end
  end
end
