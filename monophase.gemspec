# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "monophase"
  spec.version       = "0.1.0"
  spec.authors       = ["Dong-Wook Kim"]
  spec.email         = ["onepunch1120@gmail.com"]

  spec.summary       = "A one-column minimal responsive Jekyll blog theme"
  spec.homepage      = "https://duk1003.github.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", "~> 3.9"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.15"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.7"
  spec.add_runtime_dependency "kramdown-parser-gfm", "~> 1.1"
end
