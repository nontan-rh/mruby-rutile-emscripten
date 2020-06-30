#!/usr/bin/env pwsh

$script_path = $MyInvocation.MyCommand.Path
$proj_dir = (get-item $script_path).Directory.Parent.FullName
$proj_name = "mruby-rutile-emscripten"
$image_tag = "nontanrh/$proj_name"

cd "$proj_dir"

docker run -v "${PWD}:/$proj_name" -i -t "$image_tag" bash
