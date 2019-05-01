#
# Cookbook:: java_openjdk
# Recipe:: windows
#
# Copyright:: 2019, Nghiem Ba Hieu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

java_path = Chef::Util::PathHelper.join(ENV['ProgramFiles'] || 'C:\Program Files', 'Java')
openjdk_cache_file_path = Chef::Util::PathHelper.join(Chef::Config[:file_cache_path], 'openjdk-11.0.2_windows-x64b-bin.zip')
pkg_checksum = node['java_openjdk']['windows']['checksum'] if node['java_openjdk']['windows']['checksum']

remote_file openjdk_cache_file_path do
  source node['java_openjdk']['windows']['packages']
  checksum pkg_checksum
  backup false
  action :create
end

powershell_script 'unpack openjdk' do
  code <<-DEPLOY

    if (Test-Path "#{node['java']['java_home']}/bin/java.exe")
    {
        Write-Host "Existing extraction found.. exit!"
        Exit 0
    }

    $unpacked = $false

    if ($PSVersionTable.PSVersion.Major -ge 5)
    {
         try
         {
             Expand-Archive #{openjdk_cache_file_path} #{node['java']['java_home']}

             $unpacked = $true

             Write-Host ("Successfully extract files to {0}" -f "#{openjdk_cache_file_path}")
         }
         catch
         {
             Write-Host "Failed to extract files by Expand-Archive cmdlet.."
         }
    }

    if (-not $unpacked)
    {
        Write-Host "Attempting it again with [System.IO.Compression.ZipFile]::ExtractToDirectory"

        try
        {
            # Load [System.Io.Compression.FileSystem
            Add-Type -AssemblyName System.IO.Compression.FileSystem
        }
        catch
        {
            # If failed, try to load [System.IO.Compression.ZipFile]
            Add-Type -AssemblyName System.IO.Compression.ZipFile
        }

        try
        {
            # Try to unpack the package
            [System.IO.Compression.ZipFile]::ExtractToDirectory("#{openjdk_cache_file_path}", "#{java_path}")
            Write-Host ("Successfully extract files to {0}" -f "#{node['java']['java_home']}")
        }
        catch
        {
            Write-Host "Failed to extract the files.. exit!"
            Exit 1
        }
    }
  DEPLOY
end

if node['java']['java_home'] && !node['java']['java_home'].nil?
  java_home_win = node['java']['java_home']
  env 'JAVA_HOME' do
    value java_home_win
  end

  windows_path "#{java_home_win}\\bin" do
    action :add
  end
end
