require './car'
describe Car, 'class' do
  it "should be able to spawn instances" do
    Car.new.should be_instance_of Car
  end
  context "when creating instance" do
    context "should accept hash of values " do
      it 'for 2 out of 3 attributes' do
        x = Car.new(:engine => :gas, :size => 1.6)
        x.engine.should eq(:gas)
        x.size.should eq(1.6)
      end
      it 'for engine, turbo and size' do
        x = Car.new(:engine => :gas, :size => 2.0, :turbo => true)
        x.engine.should eq(:gas)
        x.size.should eq(2.0)
        x.turbo.should eq(true)
      end
    end
    context 'should raise exception' do
      it 'when value isn\'t engine, size or turbo' do
        expect(Car.new(:asdfas => "LOL")).to raise_error
      end
    end
    it 'should accept and execute blocks' do
      a = Car.new do
        self.engine = :diesel
        self.size = 3.0
      end
      a.engine.should eq(:diesel)
      a.size.should eq(3.0)
    end
  end
  context 'using plain :key method' do
    it 'when not given any arguments, should return variable' do
      Car.new(:engine => :gas).engine.should eq(:gas)
    end
    it 'when given an argument, should set variable' do
      c = Car.new 
      c.engine :gas
      c.engine.should eq(:gas)
    end

  end
end