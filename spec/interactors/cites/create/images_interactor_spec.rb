# frozen_string_literal: true

require 'rails_helper'

describe Interactors::Cites::Create::ImagesInteractor do
  subject(:interactor) { described_class.call(cite: cite, entity: entity, user: user, params: params) }

  let(:cite) do
    mention = create(:mention, entities: [entity])
    create(:cite, entity: entity, mention: mention)
  end
  let(:entity) { create(:entity) }
  let(:user) { create(:user) }

  # NOTE: we are not interested if `destroy` value is `true` or `false`
  context 'when entity does not have passed image' do
    let(:params) do
      [{ 'id' => nil, 'destroy' => false,
         'file' => Rack::Test::UploadedFile.new('spec/fixtures/files/adriana_chechik.jpg') }]
    end

    it 'creates new image with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(Image, :count).by(1)
      expect(Image.last).to have_attributes(
        user_id: user.id,
        image_data: include('metadata' => include('filename' => 'adriana_chechik.jpg'))
      )
    end

    it 'creates 2 images_relation (for cite and entity) with correct attributes', aggregate_failures: true do
      expect { interactor }.to change(ImagesRelation, :count).by(2)
      expect(ImagesRelation.find_by(relation: cite)).to have_attributes(image: Image.last, user: user)
      expect(ImagesRelation.find_by(relation: entity)).to have_attributes(image: Image.last, user: user)
    end
  end

  context 'when entity already has the passed image and destroy is `true`' do
    let!(:images_relation) { create(:images_relation, image: image, relation: entity) }
    let(:image) { create(:image) }
    # NOTE: we are not interested in `file` content if we are destroying
    let(:params) { [{ 'id' => image.id, 'destroy' => true, 'file' => {} }] }

    before do
      create(:images_relation, relation: create(:entity))
    end

    it 'destroys the images_relation', aggregate_failures: true do
      expect { interactor }.to change(ImagesRelation, :count).by(-1)
      expect { images_relation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not destroy image' do
      expect { interactor }.not_to change(Image, :count)
    end
  end

  context 'when did nothing with images' do
    let(:image) { create(:image) }
    let(:params) { [{ 'id' => image.id, 'destroy' => false, 'file' => {} }] }
    let!(:images_relation) { create(:images_relation, image: image, relation: entity) }

    it 'creates images_relation only for cite', aggregate_failures: true do
      expect { interactor }.to change(ImagesRelation, :count)
      expect(ImagesRelation.last).to have_attributes(image: image, user: user, relation: cite)
    end
  end

  context 'when images is an empty array' do
    let(:params) { [] }

    it 'does not fail' do
      expect { interactor }.not_to raise_error
    end
  end
end
