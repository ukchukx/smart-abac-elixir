# Copyright (C) 2022 Geovane Fedrecheski <geonnave@gmail.com>
#               2022 Universidade de São Paulo
#               2022 LSI-TEC
#
# This file is part of the SwarmOS project, and it is subject to
# the terms and conditions of the GNU Lesser General Public License v2.1.
# See the file LICENSE in the top level directory for more details.

import Config

config :smart_abac, hierarchy_client: SmartABAC.Hierarchy, hierarchy_file: "example_home_policy.n3", debug_pdp: false

config :logger, level: :debug

import_config "#{Mix.env()}.exs"
