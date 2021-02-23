# frozen_string_literal: true

require 'rails_helper'

describe Elastic::CheckIndexExists do
  subject { described_class.call(params) }

  context 'when input params does not include index_name' do
    let(:params) { {} }

    it { expect { subject }.to raise_error }
  end

  context 'when index does not exist' do
    let(:params) { {index_name: rand.to_s} }

    it { is_expected.to have_attributes(object: false) }
    it { is_expected.to be_failure }
  end

  context 'when index exists' do
    let(:params) { {index_name: Elastic::IndexName.wildcard} }

    it { is_expected.to have_attributes(object: true) }
    it { is_expected.to be_success }
  end

  describe '#allow_no_indices' do
    let(:params) { {index_name: index_name, allow_no_indices: allow_no_indices } }
    let(:index_name) { Elastic::IndexName.new_picker("#{rand.to_s}*") }

    # NOTE: I do not have idea why this feature needed. Because it erroneously
    # tells that there are indexes with some mask. But may be not not. See example at the end of file
    #
    context 'when true' do
      let(:allow_no_indices) { true }

      it { is_expected.to be_success }
      it { expect(subject.object).to eq(true) }
    end

    context 'when false' do
      let(:allow_no_indices) { false }

      it { is_expected.to be_failure }
      it { expect(subject.object).to eq(false) }
    end
  end
end

# ➜  hub git:(master) ✗ curl -I "localhost:9200/123*?allow_no_indices=true"
# HTTP/1.1 200 OK
# content-type: application/json; charset=UTF-8
# content-length: 2
#
# ➜  hub git:(master) ✗ curl -I "localhost:9200/123*?allow_no_indices=false"
# HTTP/1.1 404 Not Found
# content-type: application/json; charset=UTF-8
# content-length: 353
#
#
# --------------------------------------------------------------------------
#
#
# ➜  hub git:(master) ✗ curl -I "localhost:9200/123?allow_no_indices=true"
# HTTP/1.1 404 Not Found
# content-type: application/json; charset=UTF-8
# content-length: 347
#
# ➜  hub git:(master) ✗ curl -I "localhost:9200/123?allow_no_indices=false"
# HTTP/1.1 404 Not Found
# content-type: application/json; charset=UTF-8
# content-length: 347
