def configure_gems(conf)
  conf.gembox 'default'
  conf.gem :github => 'mattn/mruby-require'
end

MRuby::Build.new do |conf|
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :gcc
  end

  configure_gems conf
end

MRuby::CrossBuild.new('emscripten') do |conf|
  toolchain :clang

  # C compiler settings
  conf.cc do |cc|
    cc.command = ENV['CC'] || 'emcc'
    cc.flags = [ENV['CFLAGS'] || %w()]
    cc.include_paths = ["#{root}/include"]
    cc.defines = %w()
    cc.option_include_path = %q[-I"%s"]
    cc.option_define = '-D%s'
    cc.compile_options = %Q[%{flags} -MMD -o "%{outfile}" -c "%{infile}"]
  end

  # Linker settings
  conf.linker do |linker|
    linker.command = ENV['LD'] || 'emcc'
    linker.flags = [ENV['LDFLAGS'] || %w()]
    linker.flags_before_libraries = %w()
    linker.libraries = %w()
    linker.flags_after_libraries = %w()
    linker.library_paths = %w()
    linker.option_library = '-l%s'
    linker.option_library_path = '-L%s'
    linker.link_options = %Q[%{flags} -o "%{outfile}" %{objs} %{libs}]
  end

  # Archiver settings
  conf.archiver do |archiver|
    archiver.command = ENV['AR'] || 'emar'
    archiver.archive_options = %Q[rs "%{outfile}" %{objs}]
  end

  # file extensions
  conf.exts do |exts|
    exts.object = '.o'
    exts.executable = '.js'
    exts.library = '.a'
  end

  configure_gems conf
end
