require 'spec_helper'

describe do
  let(:config) {
    %[
      xymon_server 127.0.0.1
      xymon_port   1984
      color        red
      hostname     host1
      testname     column1
      name_key     field1
    ]
  }

  let(:driver) {
    Fluent::Test::OutputTestDriver.new(Fluent::XymonOutput, 'test.metrics').configure(config)
  }

  describe 'config' do
    context do
      subject {driver.instance.xymon_server}
      it{should == '127.0.0.1'}
    end

    context do
      subject {driver.instance.xymon_port}
      it{should == '1984'}
    end

    context do
      subject {driver.instance.color}
      it{should == 'red'}
    end

    context do
      subject {driver.instance.hostname}
      it{should == 'host1'}
    end

    context do
      subject {driver.instance.testname}
      it{should == 'column1'}
    end

    context do
      subject {driver.instance.name_key}
      it{should == 'field1'}
    end

  end

  describe 'build_message' do
    context do
      subject {driver.instance.build_message(0, 50)}
      it{should == "status #{driver.instance.hostname}.#{driver.instance.testname} #{driver.instance.color} #{Time.at(0)} #{driver.instance.testname} #{driver.instance.name_key}=50\n\n#{driver.instance.name_key}=50"}
    end
  end
  
  describe 'emit' do

    let(:posted) {
      d = driver
      mock(IO).popen("nc '#{d.instance.xymon_server}' '#{d.instance.xymon_port}'", 'w').times 1
      d.emit({ 'field1' => 50, 'otherfield' => 99})
      d.run
    }

    context do
      subject {posted}
      it{should_not be_nil}
    end
  end
end
