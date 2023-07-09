# frozen_string_literal: true

require 'rails_helper'

describe Extractors::YoutubeCom::IndexInteractor do
  subject { described_class.call(q: title) }

  describe 'https://youtu.be' do
    context 'with url "https://youtu.be/xZgZLOq1JKU"' do
      let(:title) { 'https://youtu.be/xZgZLOq1JKU' }

      before do
        expect(Extractors::YoutubeCom::ListVideosInteractor).to(
          receive(:call).with(id: 'xZgZLOq1JKU').and_return(OpenStruct.new(object: {}))
        )
      end

      it { expect { subject }.not_to raise_error }
    end
  end


  describe '/watch' do
    context 'with url "https://www.youtube.com/watch?v=aircAruvnKk"' do
      let(:title) { 'https://www.youtube.com/watch?v=aircAruvnKk' }

      before do
        expect(Extractors::YoutubeCom::ListVideosInteractor).to(
          receive(:call).with(id: 'aircAruvnKk').and_return(OpenStruct.new(object: {}))
        )
      end

      it { expect { subject }.not_to raise_error }
    end

    context 'with url "https://www.youtube.com/watch?v=zUHRNLVpoIE&list=PL3mtAHT_eRewFew2hKdiWkk5Jmhb_gw6e"' do
      let(:title) { 'https://www.youtube.com/watch?v=zUHRNLVpoIE&list=PL3mtAHT_eRewFew2hKdiWkk5Jmhb_gw6e' }

      before do
        expect(Extractors::YoutubeCom::ListVideosInteractor).to(
          receive(:call).with(id: 'zUHRNLVpoIE').and_return(OpenStruct.new(object: {}))
        )
        expect(Extractors::YoutubeCom::ListPlaylistsInteractor).to(
          receive(:call).with(id: 'PL3mtAHT_eRewFew2hKdiWkk5Jmhb_gw6e').and_return(OpenStruct.new(object: {}))
        )
      end

      it { expect { subject }.not_to raise_error }
    end

    context 'with url "https://www.youtube.com/watch?v=JIviltfpul0&feature=youtu.be&t=2987"' do
      let(:title) { 'https://www.youtube.com/watch?v=JIviltfpul0&feature=youtu.be&t=2987' }

      before do
        expect(Extractors::YoutubeCom::ListVideosInteractor).to(
          receive(:call).with(id: 'JIviltfpul0').and_return(OpenStruct.new(object: {}))
        )
      end

      it { expect { subject }.not_to raise_error }
    end

    context 'with url "https://www.youtube.com/watch?v=26uABexmOX4&feature=youtu.be&list=PLRqwX-V7Uu6YPSwT06y_AEYTqIwbeam3y"' do
      let(:title) do
        'https://www.youtube.com/watch?v=26uABexmOX4&feature=youtu.be&list=PLRqwX-V7Uu6YPSwT06y_AEYTqIwbeam3y'
      end

      before do
        expect(Extractors::YoutubeCom::ListVideosInteractor).to(
          receive(:call).with(id: '26uABexmOX4')
        ).and_return(OpenStruct.new(object: {}))

        expect(Extractors::YoutubeCom::ListPlaylistsInteractor).to(
          receive(:call).with(id: 'PLRqwX-V7Uu6YPSwT06y_AEYTqIwbeam3y').and_return(OpenStruct.new(object: {}))
        )
      end

      it { expect { subject }.not_to raise_error }
    end
  end

  describe '/channel' do
    context 'with url "https://www.youtube.com/channel/UCXmseTCR4w5q36pupOJKegw"' do
      let(:title) { 'https://www.youtube.com/channel/UCXmseTCR4w5q36pupOJKegw' }

      before do
        expect(Extractors::YoutubeCom::ListChannelsInteractor).to(
          receive(:call).with(id: 'UCXmseTCR4w5q36pupOJKegw').and_return(OpenStruct.new(object: {}))
        )
      end

      it { expect { subject }.not_to raise_error }
    end
  end

  describe '/playlist' do
    context 'with url "https://www.youtube.com/playlist?list=PLLvvXm0q8zUbiNdoIazGzlENMXvZ9bd3x"' do
      let(:title) { 'https://www.youtube.com/playlist?list=PLLvvXm0q8zUbiNdoIazGzlENMXvZ9bd3x' }

      before do
        expect(Extractors::YoutubeCom::ListPlaylistsInteractor).to(
          receive(:call).with(id: 'PLLvvXm0q8zUbiNdoIazGzlENMXvZ9bd3x').and_return(OpenStruct.new(object: {}))
        )
      end

      it { expect { subject }.not_to raise_error }
    end
  end

  describe '/user' do
    context 'with url "https://www.youtube.com/user/LinusTechTips"' do
      let(:title) { 'https://www.youtube.com/user/LinusTechTips' }

      before do
        expect(Extractors::YoutubeCom::ListChannelsInteractor).to(
          receive(:call).with(for_username: 'LinusTechTips').and_return(OpenStruct.new(object: {}))
        )
      end

      it { expect { subject }.not_to raise_error }
    end
  end

  describe '/c' do
    before do
      expect(Extractors::YoutubeCom::GetChannelIdFromUrlInteractor).to(
        receive(:call).with(url: title).and_return(
          OpenStruct.new(object: 'channel_id')
        )
      )

      expect(Extractors::YoutubeCom::ListChannelsInteractor).to(
        receive(:call).with(id: 'channel_id').and_return(OpenStruct.new(object: {}))
      )
    end

    context 'with url "https://www.youtube.com/c/DevDay2GIS/playlists"' do
      let(:title) { 'https://www.youtube.com/c/DevDay2GIS/playlists' }

      it { expect { subject }.not_to raise_error }
    end

    context 'with url "https://www.youtube.com/c/TheCodingTrain/playlists?view=50&sort=dd&shelf_id=10"' do
      let(:title) { 'https://www.youtube.com/c/TheCodingTrain/playlists?view=50&sort=dd&shelf_id=10' }

      it { expect { subject }.not_to raise_error }
    end

    context 'with url "https://www.youtube.com/c/Confreaks/videos?view=0&sort=p&shelf_id=0"' do
      let(:title) { 'https://www.youtube.com/c/Confreaks/videos?view=0&sort=p&shelf_id=0' }

      it { expect { subject }.not_to raise_error }
    end

    context 'with url "https://www.youtube.com/c/SberMarketTech"' do
      let(:title) { 'https://www.youtube.com/c/SberMarketTech' }

      it { expect { subject }.not_to raise_error }
    end

    context 'with url "https://www.youtube.com/c/%D0%A7%D0%B8%D0%BA%D0%B5%D0%BD%D0%9A%D0%B0%D1%80%D1%80%D0%B8"' do
      let(:title) { 'https://www.youtube.com/c/%D0%A7%D0%B8%D0%BA%D0%B5%D0%BD%D0%9A%D0%B0%D1%80%D1%80%D0%B8' }

      it { expect { subject }.not_to raise_error }
    end

    context 'with url "https://www.youtube.com/@CodeAesthetic"' do
      let(:title) { 'https://www.youtube.com/@CodeAesthetic' }

      it { expect { subject }.not_to raise_error }
    end
  end

  context 'with url "https://www.youtube.com/GAMING"' do
    let(:title) { 'https://www.youtube.com/GAMING' }

    it { expect { subject }.not_to raise_error }
  end

  context 'with url "https://www.youtube.com/results?search_query=Comment+Out"' do
    let(:title) { 'https://www.youtube.com/results?search_query=Comment+Out' }

    it { expect { subject }.not_to raise_error }
  end
end
