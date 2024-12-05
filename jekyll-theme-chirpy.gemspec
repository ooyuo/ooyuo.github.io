# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "durun-log-theme"  # 당신의 테마 이름
  spec.version = "1.0.0"  # 첫 버전으로 시작
  spec.authors = ["ooyuo"]  # 당신의 GitHub 사용자명
  spec.email = ["durun0415@gmail.com"]  # 당신의 이메일
  spec.summary = "A technical blog theme based on Chirpy"  # 테마 설명
  spec.homepage = "https://github.com/ooyuo/ooyuo.github.io"  # 당신의 GitHub 저장소 주소
  spec.license = "MIT"  # 라이선스 유지
  
  spec.files = `git ls-files -z`.split("\x0").select { |f|
    f.match(%r!^((_(includes|layouts|sass|(data\/(locales|origin)))|assets)\/|README|LICENSE)!i)
  }
  
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/ooyuo/ooyuo.github.io/issues",
    "documentation_uri" => "https://github.com/ooyuo/ooyuo.github.io/#readme",
    "homepage_uri" => "https://ooyuo.github.io",
    "source_code_uri" => "https://github.com/ooyuo/ooyuo.github.io",
    "wiki_uri" => "https://github.com/ooyuo/ooyuo.github.io/wiki",
    "plugin_type" => "theme"
  }

  # 의존성 패키지들은 그대로 유지
  spec.required_ruby_version = "~> 3.1"
  spec.add_runtime_dependency "jekyll", "~> 4.3"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
  spec.add_runtime_dependency "jekyll-redirect-from", "~> 0.16"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.8"
  spec.add_runtime_dependency "jekyll-archives", "~> 2.2"
  spec.add_runtime_dependency "jekyll-sitemap", "~> 1.4"
  spec.add_runtime_dependency "jekyll-include-cache", "~> 0.2"
end