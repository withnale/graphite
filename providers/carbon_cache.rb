#
# Cookbook Name:: graphite
# Provider:: carbon_cache
#
# Copyright 2014, Heavy Water Software Inc.
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
#

def whyrun_supported?
  true
end

use_inline_resources

action :create do
  if new_resource.install 
    set_updated { install_python_pip }
  end 
  if new_resource.fragment
    set_updated { create_tracking_fragment }
  end
end

def install_python_pip
  python_pip new_resource.backend_name do
    new_resource.backend_attributes.each { |attr, value| send(attr, value) }
    Chef::Log.info "Installing storage backend: #{package_name}"
    action :install
  end
end

def create_tracking_fragment
  file new_resource.name do
    content ChefGraphite.ini_file(resources_to_hashes([new_resource]))
    action :create
  end
end

def set_updated
  r = yield
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
