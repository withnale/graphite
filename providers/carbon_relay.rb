#
# Cookbook Name:: graphite
# Provider:: carbon_relay
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

include ChefGraphite::Mixins

def whyrun_supported?
  true
end

use_inline_resources

action :create do
  set_updated { create_tracking_fragment } if new_resource.fragment
end

def create_tracking_fragment
  file new_resource.fragment do
    content ChefGraphite.ini_file(resources_to_hashes([new_resource]))
    action :create
  end
end

def set_updated
  r = yield
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end

action :delete do
end
