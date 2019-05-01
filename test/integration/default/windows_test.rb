# # encoding: utf-8

# Inspec test for recipe java_openjdk::windows

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

return unless os.windows?

VERSION = '11.0.2'

describe file("C:\\Program Files\\Java\\jdk-#{VERSION}\\bin\\java.exe") do
  it { should exist }
end

describe command('java --version') do
  its('stdout') { should match /11\.0\.2/ }
end
