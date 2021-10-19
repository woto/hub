# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :request do
  describe '#update' do
    context 'with user', responsible: :user do
      subject { put post_path(id: post.id), params: { post: params } }

      before { sign_in(Current.responsible) }

      context 'when passed new title' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { title: 'new title' } }

        specify do
          expect { subject }.to change { post.reload.title }.to('new title')
        end
      end

      context 'when passed new tags' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { tags: ['', 'new tag'] } }

        specify do
          expect { subject }.to change { post.reload.tags }.to(['', 'new tag'])
        end
      end

      context 'when passed new currency' do
        let(:post) { create(:post, user: Current.responsible, currency: :usd) }
        let(:params) { { currency: :rub } }

        specify do
          expect { subject }.to change { post.reload.currency }.to('rub')
        end
      end

      context 'when passed published at' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { published_at: 1.month.since.round } }

        specify do
          expect { subject }.not_to(change { post.reload.published_at })
        end
      end

      context 'when passed status' do
        let(:post) { create(:post, user: Current.responsible, status: :draft_post) }
        let(:params) { { status: :pending_post } }

        specify do
          expect { subject }.to change { post.reload.status }.to('pending_post')
        end
      end

      context 'when passed intro' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { intro: 'new intro' } }

        specify do
          expect { subject }.not_to(change { post.reload.intro.to_plain_text })
        end
      end

      context 'when passed body' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { body: 'new body' } }

        specify do
          expect { subject }.to change { post.reload.body.to_plain_text }.to('new body')
        end
      end

      context 'when passed new_category_id' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { post_category_id: post_category.id } }
        let(:post_category) { create(:post_category, realm: post.realm) }

        specify do
          expect { subject }.to change { post.reload.post_category_id }.to(post_category.id)
        end
      end

      context 'when passed user_id' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { user_id: user.id } }
        let(:user) { create(:user) }

        specify do
          expect { subject }.not_to(change { post.reload.user_id })
        end
      end

      context 'when passed new realm_id' do
        let(:post) { create(:post, user: Current.responsible, status: :pending_post) }
        let(:params) { { realm_id: post_category.realm.id, post_category_id: post_category.id } }
        let(:post_category) { create(:post_category) }

        specify do
          expect { subject }.to change { post.reload.realm_id }.to(post_category.realm.id)
        end
      end

      context 'when passed new extra_options' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { extra_options: extra_options } }
        let(:extra_options) { { 'a' => 'b' } }

        specify do
          expect { subject }.to change { post.reload.extra_options }.to(extra_options)
        end
      end
    end

    context 'with admin', responsible: :admin do
      subject { put post_path(id: post.id), params: { post: params } }

      before { sign_in(Current.responsible) }

      context 'when passed user_id' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { user_id: user.id } }
        let(:user) { create(:user) }

        specify do
          expect { subject }.to change { post.reload.user_id }.to(user.id)
        end
      end

      context 'when passed published_at' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { published_at: published_at } }
        let(:published_at) { 1.month.since.round }

        specify do
          expect { subject }.to change { post.reload.published_at }.to(published_at)
        end
      end

      context 'when passed intro' do
        let(:post) { create(:post, user: Current.responsible) }
        let(:params) { { intro: 'new intro' } }

        specify do
          expect { subject }.to change { post.reload.intro.to_plain_text }.to('new intro')
        end
      end
    end

    context 'with another user', responsible: :user do
      subject { put post_path(id: post.id), params: {} }

      let(:post) { create(:post, user: Current.responsible) }

      before { sign_in(create(:user)) }

      specify do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    subject { post posts_path, params: { post: params } }

    before { sign_in(user) }

    let(:user) { Current.responsible }
    let(:another_user) { create(:user) }
    let(:published_at) { 1.year.ago.round }

    let(:params) do
      {
        title: 'title',
        status: :pending_post,
        body: 'body',
        post_category_id: post_category.id,
        realm_id: post_category.realm.id,
        currency: :rub,
        tags: ['', 'tag'],
        extra_options: { 'a' => 'b' },
        user_id: another_user.id,
        published_at: published_at,
        intro: 'intro'
      }
    end
    let(:post_category) { create(:post_category) }

    context 'with user', responsible: :user do
      specify do
        expect { subject }.to change(Post, :count).by(1)
        post = Post.last
        expect(post.title).to eq('title')
        expect(post.status).to eq('pending_post')
        expect(post.body.to_plain_text).to eq('body')
        expect(post.post_category).to eq(post_category)
        expect(post.realm).to eq(post_category.realm)
        expect(post.currency).to eq('rub')
        expect(post.tags).to eq(['', 'tag'])
        expect(post.extra_options).to eq({ 'a' => 'b' })
        # staff permissions
        expect(post.user).to eq(user)
        expect(post.published_at).to be_nil
        expect(post.intro.to_plain_text).to eq('')
      end
    end

    context 'with admin', responsible: :admin do
      specify do
        expect { subject }.to change(Post, :count).by(1)
        post = Post.last
        expect(post.title).to eq('title')
        expect(post.status).to eq('pending_post')
        expect(post.body.to_plain_text).to eq('body')
        expect(post.post_category).to eq(post_category)
        expect(post.realm).to eq(post_category.realm)
        expect(post.currency).to eq('rub')
        expect(post.tags).to eq(['', 'tag'])
        expect(post.extra_options).to eq({ 'a' => 'b' })
        # staff permissions
        expect(post.user).to eq(another_user)
        expect(post.published_at).to eq(published_at)
        expect(post.intro.to_plain_text).to eq('intro')
      end
    end
  end

  describe '#destroy' do
    subject { delete post_path(post) }

    before { sign_in(user) }

    context 'with user', responsible: :user do
      let(:user) { Current.responsible }
      let!(:post) { create(:post, user: Current.responsible) }

      specify do
        expect { subject }.to change { post.reload.status }.to('removed_post')
      end
    end

    context 'with another user', responsible: :user do
      let(:user) { create(:user) }
      let(:post) { create(:post, user: Current.responsible) }

      specify do
        expect { subject }.not_to(change { post.reload.status })
      end
    end

    context 'with admin', responsible: :admin do
      let(:user) { Current.responsible }
      let(:post) { create(:post, user: create(:user)) }

      specify do
        expect { subject }.to change { post.reload.status }.to('removed_post')
      end
    end
  end
end
