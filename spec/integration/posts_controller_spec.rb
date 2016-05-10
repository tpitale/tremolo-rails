require 'spec_helper'

describe PostsController do
  let(:controller) {PostsController.new}
  let(:session) {{}}

  describe '#tracker' do
    before(:each) do
      SecureRandom.stubs(:uuid).returns('54321')

      controller.stubs(:session).returns(session)
    end

    it 'builds a new tracker' do
      tracker = controller.tracker

      expect(tracker.respond_to?(:increment)).to eq(true)
      expect(tracker.respond_to?(:decrement)).to eq(true)
    end

    it 'appends tracker to the notification payload' do
      payload = {}

      # calling fetch without config results in a new NoopTracker each time
      Tremolo.stubs(:fetch).returns('tracker')

      controller.append_info_to_payload(payload)

      expect(payload["tremolo.tracker"]).to eq(controller.tracker)
    end
  end

  describe "tracking exceptions" do
    let(:tracker) {stub(:increment)}

    before(:each) do
      controller.stubs(:tracker).returns(tracker)
    end

    it 'still raises the error' do
      expect { controller.destroy }.to raise_exception(NotImplementedError)
    end

    it 'tracks the error' do
      controller.track_exception_with_tremolo(NotImplementedError.new)

      expect(tracker).to have_received(:increment).with('exception', name: 'NotImplementedError')
    end

    it 'tracks the error and raises' do
      expect { 
        controller.track_exception_with_tremolo_and_raise(NotImplementedError.new)
      }.to raise_exception(NotImplementedError)

      expect(tracker).to have_received(:increment).with('exception', name: 'NotImplementedError')
    end
  end
end
