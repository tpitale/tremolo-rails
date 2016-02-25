require 'spec_helper'

describe Tremolo::Subscribers::Page do

  let(:tracker) { Tremolo.fetch(:noop) }
  let(:now) {Time.now.to_i}
  let(:duration) {49}
  let(:client_id) {SecureRandom.uuid}

  let(:payload) {
    # args example from:
    # http://edgeguides.rubyonrails.org/active_support_instrumentation.html#process-action-action-controller
    {
      controller: "PostsController",
      action: "index",
      params: {"action" => "index", "controller" => "posts"},
      format: :html,
      path: "/posts",
      status: 200,
      view_runtime: 46.848,
      db_runtime: 0.157,
      'tremolo.client_id' => client_id,
      'tremolo.tracker' => tracker
    }
  }

  let(:tags) {
    {
      path: '/posts',
      hostname: 'domain.com',
      method: 'GET',
      status: 200,
      format: :html,
      controller: 'posts',
      action: 'index',
      client_id: client_id
    }
  }

  context "on a GET request" do
    let(:args) {
      [
        "process_action.action_controller", # name
        now - duration, # starting
        now, # ending
        SecureRandom.uuid, # Rails' transaction_id
        payload.merge(method: "GET")
      ]
    }

    let(:page) {Tremolo::Subscribers::Page.new(args)}

    before(:each) do
      tracker.stubs(:increment)
      page.track!
    end

    it 'increments a pageview stat with tags' do
      expect(tracker).to have_received(:increment).with('pageview', tags)
    end
  end

  context "on a non-GET request" do
    let(:args) {
      [
        "process_action.action_controller", # name
        now - duration, # starting
        now, # ending
        client_id, # transaction_id
        payload.merge(method: "POST")
      ]
    }

    let(:page) {Tremolo::Subscribers::Page.new(args)}

    before(:each) do
      tracker.stubs(:increment)
      page.track!
    end

    it 'increments a pageview stat with tags' do
      expect(tracker).to have_received(:increment).with('pageview', tags.merge(method: 'POST'))
    end
  end

end
