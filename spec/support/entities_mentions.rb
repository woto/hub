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
  let!(:entity7) { create(:entity, title: 'Leah Gotti') }
  let!(:entity8) { create(:entity, title: 'Cory Chase') }
  let!(:entity9) { create(:entity, title: 'Amelia Li') }
  let!(:entity10) { create(:entity, title: 'Sophia Leone') }
  let!(:entity11) { create(:entity, title: 'Kendra Lust') }
  let!(:entity12) { create(:entity, title: 'Valentina Nappi') }
  let!(:entity13) { create(:entity, title: 'Aletta Ocean') }
  let!(:entity14) { create(:entity, title: 'Alura Jenson') }
  let!(:entity15) { create(:entity, title: 'Angela White') }
  let!(:entity16) { create(:entity, title: 'Alyx Star') }
  let!(:entity17) { create(:entity, title: 'Natasha Nice') }
  let!(:entity18) { create(:entity, title: 'Abella Danger') }
  let!(:entity19) { create(:entity, title: 'Brandi Love') }

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
  let!(:mention11) { create(:mention, entities: [entity7], title: 'Cherie DeVille') }
  let!(:mention12) { create(:mention, entities: [entity7, entity8], title: 'Alexis Fawx') }
  let!(:mention13) { create(:mention, entities: [entity7, entity8, entity9], title: 'Ariella Ferrera') }
  let!(:mention14) { create(:mention, entities: [entity10], title: 'Syren Demer') }
  let!(:mention15) { create(:mention, entities: [entity10, entity11], title: 'Emily Willis') }
  let!(:mention16) { create(:mention, entities: [entity10, entity12], title: 'Lena Paul') }
  let!(:mention17) { create(:mention, entities: [entity10, entity13], title: 'Riley Reid') }
  let!(:mention18) { create(:mention, entities: [entity10, entity14], title: 'Krissy Lynn') }
  let!(:mention19) { create(:mention, entities: [entity10, entity15], title: 'Kenzie Reeves') }
  # rubocop:enable RSpec/IndexedLet, RSpec/LetSetup
end
# rubocop:enable RSpec/MultipleMemoizedHelpers)
