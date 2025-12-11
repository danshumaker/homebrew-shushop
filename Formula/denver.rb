class Denver < Formula
  desc "denver dotfiles payload for installation and uninstallation scripts"
  homepage "https://github.com/danshumaker/homebrew-denver"
  version "2025-12-11_00_30_13"
  url "https://github.com/danshumaker/homebrew-denver/archive/refs/tags/#{version}.tar.gz"
  sha256 "1dee144864a8b13128ad8e30ccb2a021c67c6c4e84d56f64d008d75b30e6a1e6"
  license "MIT"

  def install
    # Install everything into pkgshare except the Formula directory itself
    payload = Dir["*"] - ["Formula"]
    pkgshare.install payload
  end

  def caveats
    <<~EOS
      The denver payload has been installed into:
        #{pkgshare}

      To install denver fully:
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/danshumaker/homebrew-denver/main/install.sh)"

      To uninstall denver:
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/danshumaker/homebrew-denver/main/uninstall.sh)"
    EOS
  end
end
