require 'minitest'
require 'minitest/autorun'
require_relative '../lib/rake_deploy'

class TestRakeDeploy < Minitest::Test
  def fixture_data
    File.join(File.dirname(__FILE__), 'fixture/sample1.yml')
  end

  def test_can_autogen_rake_task
    RakeDeploy.load_file(fixture_data)
    ObjectSpace.each_object(Rake::Application) do |app|
      assert_equal "deploy:staging", app.tasks.first.name
    end
  end
end

class TestRsyncer < Minitest::Test
  def test_indifferent_access
    options = {source: 'mars'}
    assert_equal 'mars', RakeDeploy::Rsyncer.new('test', options).source
    options = {'source' => 'mars'}
    assert_equal 'mars', RakeDeploy::Rsyncer.new('test', options).source
  end

  def test_missing_option
    options = {source: 'mars', user: 'dan', domain: 'test.com'}
    deploy = RakeDeploy::Rsyncer.new('test', options)
    assert_raises(RakeDeploy::Error) { deploy.rsync }
  end
end
