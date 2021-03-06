require File.expand_path('../../../spec_helper', __FILE__)

module ProjectSpecs
  describe XCBuildConfiguration do

    before do
      @sut = @project.new(XCConfigurationList)
    end

    it "by the default the default configuration is not visible" do
      @sut.default_configuration_is_visible.should == '0'
    end

    it "returns the default configuration name" do
      @sut.default_configuration_name = 'Release'
      @sut.default_configuration_name.should == 'Release'
    end

    it "returns the configurations" do
      configuration = @project.new(XCBuildConfiguration)
      @sut.build_configurations.to_a.should == []
      @sut.build_configurations << configuration
      @sut.build_configurations.count.should == 1
      @sut.build_configurations.should.include?(configuration)
    end

    it "returns the build configuration with the given name" do
      configuration = @project.new(XCBuildConfiguration)
      configuration.name = 'Debug'
      @sut.build_configurations << configuration
      @sut['Debug'].name.should == 'Debug'
    end

    it "returns the build settings of a configuration given its name" do
      settings = { 'GCC_VERSION' => 'com.apple.compilers.llvm.clang.1_0'}
      configuration = @project.new(XCBuildConfiguration)
      configuration.name = 'Debug'
      configuration.build_settings = settings
      @sut.build_configurations << configuration
      @sut.build_settings('Debug').should == settings
    end

    it "sets a build setting to the given value for all the configurations" do
      ['Debug', 'Release'].each do |name|
        configuration = @project.new(XCBuildConfiguration)
        configuration.name = name
        configuration.build_settings = { 'CLANG_ENABLE_OBJC_ARC' => 'NO'}
        @sut.build_configurations << configuration
      end
      @sut.get_setting('CLANG_ENABLE_OBJC_ARC').should == {"Debug"=>"NO", "Release"=>"NO"}
    end

    it "sets a build setting to the given value for all the configurations" do
      ['Debug', 'Release'].each do |name|
        configuration = @project.new(XCBuildConfiguration)
        configuration.name = name
        configuration.build_settings = { 'CLANG_ENABLE_OBJC_ARC' => 'NO'}
        @sut.build_configurations << configuration
      end

      @sut.set_setting('CLANG_ENABLE_OBJC_ARC', 'YES')
      @sut.get_setting('CLANG_ENABLE_OBJC_ARC').should == {"Debug"=>"YES", "Release"=>"YES"}
    end

  end
end

