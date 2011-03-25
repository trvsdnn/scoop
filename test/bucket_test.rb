require File.dirname(__FILE__) + '/helper'

describe Scoop::Bucket do
  before do
    Scoop.secret_access_key = 'asdf'
    Scoop.access_key_id = 'asdf'
    @ok = Net::HTTPResponse.new(1.0, 200, 'OK')
  end

  it 'creates a new bucket' do
    Scoop.expects(:request).returns(@ok)

    bucket = Scoop::Bucket.create('blah')
    bucket.must_be_instance_of Scoop::Bucket
    bucket.name.must_equal 'blah'
  end

  it 'returns an array of all available buckets' do
    bucket = Scoop::Bucket.new('test-bucket')
    Scoop::Bucket.expects(:all).returns([ bucket ])
    buckets = Scoop::Bucket.all
    buckets.size.must_equal 1
  end

end