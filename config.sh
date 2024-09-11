set -e

zsh_setup() {
    apt update && sudo apt dist-upgrade -y
    apt install build-essential curl file git -y
    apt install git-core curl fonts-powerline -y
    apt install zsh -y
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    echo "plugins=(python pip composer doctl dotenv)" >> ~/.zshrc
}



install_hashicrop_vault() {
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | sudo tee /etc/apt/sources.list.d/hashicorp.list


  apt update
  sudo apt install vault -y

  echo "Installed successfully"
  vault --version
}


perform_do_setup() {

  # Create a playground directory to be remove at the end
  mkdir ~/playground
  cd ~/playground

  # Install Digital Ocean Monitoring tools
  curl -sSL https://agent.digitalocean.com/install.sh | sh

  # Make sure you have tools in place
  apt-get -y install autoconf automake libtool nasm make pkg-config git build-essential

  # Clean up playground
  cd ~
  rm -rf ~/playground
}

install_doctl() {
  cd ~
  wget https://github.com/digitalocean/doctl/releases/download/v1.110.0/doctl-1.110.0-linux-amd64.tar.gz
  tar xf ~/doctl-1.110.0-linux-amd64.tar.gz
  sudo mv ~/doctl /usr/local/bin
}

install_direnv() {

  sudo apt-get install direnv 
  echo export ENVTEST="Environment variables working" > .envrc
  direnv allow .
  direnv hook bash >> ~/.bashrc

}

install_cloudflared() {
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloudflare-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-archive-keyring.gpg] https://pkg.cloudflare.com/ cloudflare main" | sudo tee /etc/apt/sources.list.d/cloudflare.list
    apt update
    sudo apt install cloudflared
}

echo "Installing ZSH"
install_zsh

echo "Installing HashiCorp Vault"
install_hashicrop_vault

echo "Installing Cloudflare CLI"
install_cloudflared

echo "Installing DigitalOcean CLI"
install_doctl

perform_do_setup