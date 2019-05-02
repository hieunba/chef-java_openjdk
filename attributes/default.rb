default['java_openjdk']['skip'] = false
default['java_openjdk']['windows']['packages'] = ['https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_windows-x64_bin.zip']
default['java_openjdk']['windows']['checksum'] = 'cf39490fe042dba1b61d6e9a395095279a69e70086c8c8d5466d9926d80976d8'
default['java_openjdk']['windows']['version'] = '11.0.2'
default['java_openjdk']['windows']['package_name'] = 'Java OpenJDK Runtime Environment'
force_default['java_openjdk']['java_home'] = Chef::Util::PathHelper.join(ENV['ProgramFiles'] || 'C:\Program Files', 'Java', "jdk-#{node['java_openjdk']['windows']['version']}")
