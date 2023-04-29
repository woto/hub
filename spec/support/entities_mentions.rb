# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers)
shared_context 'with some entities/mentions structure' do
  # rubocop:disable RSpec/IndexedLet, RSpec/LetSetup
  let!(:entity1) { create(:entity, title: 'Adriana Chechik') }
  let!(:entity2) { create(:entity, title: 'Jessa Rhodes') }
  let!(:entity3) { create(:entity, title: 'Angel Rivas') }
  let!(:entity4) { create(:entity, title: 'Megan Vale') }
  let!(:entity5) { create(:entity, title: 'Sasha Rose') }
  let!(:entity6) { create(:entity, title: 'Eva Elfie') }
  let!(:mention1) { create(:mention, entities: [entity1, entity2], title: 'Mia Khalifa') }
  let!(:mention2) { create(:mention, entities: [entity1, entity3], title: 'Sunny Leone') }
  let!(:mention3) { create(:mention, entities: [entity2, entity3], title: 'Dani Daniels') }
  let!(:mention4) { create(:mention, entities: [entity1, entity2, entity3], title: 'Johnny Sins') }
  let!(:mention5) { create(:mention, title: 'Angela White') }
  let!(:mention6) { create(:mention, entities: [entity1], title: 'Ava Addams') }
  let!(:mention7) { create(:mention, entities: [entity2], title: 'Mia Malkova') }
  let!(:mention8) { create(:mention, entities: [entity3, entity4], title: 'Danny D') }
  let!(:mention9) { create(:mention, entities: [entity2, entity4], title: 'Lana Rhoades') }
  let!(:mention10) { create(:mention, entities: [entity5], title: 'Julia Ann') }
  # rubocop:enable RSpec/IndexedLet, RSpec/LetSetup
end
# rubocop:enable RSpec/MultipleMemoizedHelpers)
