require 'spec_helper'

describe Tremolo::Subscribers::Timing do

  let(:tracker) { Tremolo.fetch(:noop) }
  let(:now) {Time.now.to_i}
  let(:duration) {49} # in seconds
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
      method: "GET",
      status: 200,
      view_runtime: 46.848, # milliseconds
      db_runtime: 0.157, # milliseconds
      'tremolo.client_id' => client_id,
      'tremolo.tracker' => tracker
    }
  }

  let(:args) {
    [
      "process_action.action_controller", # name
      now - duration, # starting
      now, # ending
      SecureRandom.uuid, # Rails' transaction_id
      payload
    ]
  }

  let(:timing) {Tremolo::Subscribers::Timing.new(args)}

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

  before(:each) do
    tracker.stubs(:timing)
    timing.track!
  end

  it 'tracks total run time' do
    # convert duration time to milliseconds
    total_runtime = duration.to_f*1000
    expect(tracker).to have_received(:timing).with('runtime.total', total_runtime, tags)
  end

  it 'tracks db run time' do
    expect(tracker).to have_received(:timing).with('runtime.db', 0.157, tags)
  end

  it 'tracks view rendering run time' do
    expect(tracker).to have_received(:timing).with('runtime.view', 46.848, tags)
  end
end