# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers)
shared_context 'with some entities/mentions structure' do
  # rubocop:disable RSpec/IndexedLet, RSpec/LetSetup
  let!(:entity01) { create(:entity, title: 'Adriana Chechik') }
  let!(:entity02) { create(:entity, title: 'Jessa Rhodes') }
  let!(:entity03) { create(:entity, title: 'Angel Rivas') }
  let!(:entity04) { create(:entity, title: 'Megan Vale') }
  let!(:entity05) { create(:entity, title: 'Sasha Rose') }
  let!(:entity06) { create(:entity, title: 'Eva Elfie') }
  let!(:entity07) { create(:entity, title: 'Leah Gotti') }
  let!(:entity08) { create(:entity, title: 'Cory Chase') }
  let!(:entity09) { create(:entity, title: 'Amelia Li') }
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
  let!(:entity20) { create(:entity, title: 'Jordi El Nino Polla') }
  let!(:entity21) { create(:entity, title: 'Kaede Fuyutsuki') }

  let!(:mention01) do
    travel_to(5.days.ago) do
      create(:mention, entities: [entity01, entity02, entity20], title: 'Mia Khalifa')
    end
  end
  let!(:mention02) do
    travel_to(3.days.ago) do
      create(:mention, entities: [entity01, entity03, entity20], title: 'Sunny Leone')
    end
  end
  let!(:mention03) do
    travel_to(4.days.ago) do
      create(:mention, entities: [entity02, entity03, entity20], title: 'Dani Daniels')
    end
  end
  let!(:mention04) do
    travel_to(2.days.ago) do
      create(:mention, entities: [entity01, entity02, entity03, entity20], title: 'Johnny Sins')
    end
  end
  let!(:mention05) do
    travel_to(3.days.ago) do
      create(:mention, title: 'Angela White')
    end
  end
  let!(:mention06) do
    travel_to(3.days.ago) do
      create(:mention, entities: [entity01, entity20], title: 'Ava Addams')
    end
  end
  let!(:mention07) do
    travel_to(4.days.ago) do
      create(:mention, entities: [entity02, entity20], title: 'Mia Malkova')
    end
  end
  let!(:mention08) do
    travel_to(2.days.ago) do
      create(:mention, entities: [entity03, entity04, entity20], title: 'Danny D')
    end
  end
  let!(:mention09) do
    travel_to(3.days.ago) do
      create(:mention, entities: [entity02, entity04, entity20], title: 'Lana Rhoades')
    end
  end
  let!(:mention10) do
    travel_to(4.days.ago) do
      create(:mention, entities: [entity05, entity20], title: 'Julia Ann')
    end
  end
  let!(:mention11) do
    travel_to(0.days.ago) do
      create(:mention, entities: [entity07, entity20], title: 'Cherie DeVille')
    end
  end
  let!(:mention12) do
    travel_to(1.day.ago) do
      create(:mention, entities: [entity07, entity08, entity20], title: 'Alexis Fawx')
    end
  end
  let!(:mention13) do
    travel_to(3.days.ago) do
      create(:mention, entities: [entity07, entity08, entity09, entity10, entity20], title: 'Ariella Ferrera')
    end
  end
  let!(:mention14) do
    travel_to(2.days.ago) do
      create(:mention, entities: [entity10, entity13, entity20], title: 'Syren Demer')
    end
  end
  let!(:mention15) do
    travel_to(1.day.ago) do
      create(:mention, entities: [entity11, entity20], title: 'Emily Willis')
    end
  end
  let!(:mention16) do
    travel_to(3.days.ago) do
      create(:mention, entities: [entity10, entity12, entity13], title: 'Lena Paul')
    end
  end
  let!(:mention17) do
    travel_to(2.days.ago) do
      create(:mention, entities: [entity10, entity12, entity13], title: 'Riley Reid')
    end
  end
  let!(:mention18) do
    travel_to(1.day.ago) do
      create(:mention, entities: [entity12, entity14], title: 'Krissy Lynn')
    end
  end
  let!(:mention19) do
    travel_to(0.days.ago) do
      create(:mention, entities: [entity12, entity14, entity15], title: 'Kenzie Reeves')
    end
  end
  let!(:mention20) do
    travel_to(2.days.ago) do
      create(:mention, entities: [entity20], title: 'Carolina Sweets')
    end
  end
  let!(:mention21) do
    travel_to(3.days.ago) do
      create(:mention, entities: [entity21], title: 'Gina Jameson')
    end
  end
  # rubocop:enable RSpec/IndexedLet, RSpec/LetSetup
end
# rubocop:enable RSpec/MultipleMemoizedHelpers)
