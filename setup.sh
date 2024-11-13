# 0. check mac architecture: x86_64: intel | arm64: apple silicon
uname -m
arch
#-------------------------------------------------------------------------------------------

# 1. Homebrew: simplifies the installation of software packages and dependencies on macOS.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# add the Homebrew path /opt/homebrew/bin/brew shellenv to shell config file .zshrc
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc

#-------------------------------------------------------------------------------------------

# 2. Java(JDK) - need the JDK for compiling and running Java applications.
brew install openjdk@17
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v17)

# At salesfore, the approved JDK is Azul Zulu OpenJDK for community and SF-One JDK for enterprise
# can download the .dmg from - https://www.azul.com/core-post-download/?endpoint=zulu&uuid=5e4b91ec-d2b3-44ad-8aa8-b4d4d0485554 
# Gets installed to - /Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home

# uninstall 
brew uninstall openjdk@17 

rm -rf /opt/homebrew/etc/openssl@3/cert.pem      
rm -rf /opt/homebrew/etc/openssl@3/certs
rm -rf /opt/homebrew/etc/openssl@3/certs/.keepme
rm -rf /opt/homebrew/etc/openssl@3/ct_log_list.cnf
rm -rf /opt/homebrew/etc/openssl@3/ct_log_list.cnf.dist
rm -rf /opt/homebrew/etc/openssl@3/misc
rm -rf /opt/homebrew/etc/openssl@3/misc/CA.pl
rm -rf /opt/homebrew/etc/openssl@3/misc/tsget
rm -rf /opt/homebrew/etc/openssl@3/misc/tsget.pl
rm -rf /opt/homebrew/etc/openssl@3/openssl.cnf
rm -rf /opt/homebrew/etc/openssl@3/openssl.cnf.dist
rm -rf /opt/homebrew/etc/openssl@3/private
rm -rf /opt/homebrew/etc/openssl@3/private/.keepme

rm -rf /opt/homebrew/etc/ca-certificates/cert.pem
rm -rf /opt/homebrew/etc/ca-certificates

ls /opt/homebrew/etc/openssl@3                   
ls /opt/homebrew/etc/ca-certificates    

# check
java --version

# Setting JAVA_HOME
# find the installation path:
/usr/libexec/java_home -V

# gives
Matching Java Virtual Machines (1):
    21.0.4 (arm64) "Azul Systems, Inc." - "Zulu 21.36.17" /Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home
/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home

# set the JAVA_HOME env var
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"

# reload the shell config adter modifying .zshrc
source ~/.zshrc
#-------------------------------------------------------------------------------------------

# 3. Python
brew install python
python3 --version

#-------------------------------------------------------------------------------------------

# 4. Jetbrains IntelliJ IDEA
brew install --cask jetbrains-toolbox
open /Applications/JetBrains\ Toolbox.app

#-------------------------------------------------------------------------------------------

# 5. VSC
brew install --cask visual-studio-code
open '/Applications/Visual Studio Code.app'

#-------------------------------------------------------------------------------------------

# 6. Dependency management
brew install maven # mvn
brew install gradle # gradle
brew install pyenv # pyenv
brew install poetry # poetry

# 7. scala
brew install scala
brew install sbt


# 8. Git SSH
ls -al ~/.ssh

# RSA
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
ssh -T git@https://git.soma.salesforce.com/
git remote -v

# ED25591
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
ssh -T git@https://git.soma.salesforce.com/
git remote -v



brew install apache-spark
export SPARK_HOME=$(brew --prefix apache-spark)
export PATH="$SPARK_HOME/bin:$PATH"



# 9. Spark
git clone https://git.soma.salesforce.com/dva-transformation/sfdc-spark.git
cd sfdc-spark
git branch -a
git tag
git checkout feature-branch
git checkout tags/v3.1.1-sfdc
# compile spark using SBT: HDP: 3.2 | Scala 2.12 - This will compile Spark and skip the tests to speed up the process. You can modify the hadoop.version and scala-2.12 to match the desired version.
./build/mvn -DskipTests clean package -Dhadoop.version=3.2.0 -Pscala-2.12
# building with SBT
./dev/make-distribution.sh --name custom-spark --pip --tgz -Phadoop-3.2 -Pkubernetes -Pscala-2.12
# install - After building the project, the compiled Spark distribution will be available as a .tgz file (if you used the make-distribution.sh script) or as built artifacts within the project
tar -xvf spark-3.x.x-bin-custom-spark.tgz
mv spark-3.x.x-bin-custom-spark /usr/local/spark
# env vars - Add the following lines to your ~/.zshrc (or ~/.bash_profile if you’re using Bash):
export SPARK_HOME=/usr/local/spark
export PATH=$SPARK_HOME/bin:$PATH
source ~/.zshrc

#verify installation
spark-shell --version

# [optional] - run in standalone mode
start-master.sh
#Start the worker and connect it to the master:
start-slave.sh spark://<master-ip>:7077
#Open the Spark shell:
spark-shell --master spark://<master-ip>:7077


brew install trino
# Trino is a distributed SQL query engine for big data analytics.
# It can query data from multiple data sources such as HDFS, MySQL, S3, and more.

# Test Trino installation
trino --version
# Expected output:
# Trino CLI 1.2.0 (or whichever version was installed)

# Trino Server: Download the tarball.


pip install apache-airflow
# Apache Airflow is a platform to programmatically author, schedule, and monitor workflows.

# Test Airflow installation
airflow version
# Expected output:
# Apache Airflow X.X.X (version number installed)



brew install --cask docker
# Docker is a platform for developing, shipping, and running applications in containers.

# Test Docker installation
docker --version
# Expected output:
# Docker version X.X.X (version number installed)


brew install kubectl
# kubectl is a command-line tool for interacting with Kubernetes clusters.

# Test kubectl installation
kubectl version --client
# Expected output:
# Client Version: vX.X.X (version number installed)



brew install minikube
# Minikube is a tool for running Kubernetes locally on your machine.

# Test Minikube installation
minikube version
# Expected output:
# minikube version: vX.X.X (version number installed)



brew install helm
# Helm is a package manager for Kubernetes that helps manage Kubernetes applications.

# Test Helm installation
helm version
# Expected output:
# version.BuildInfo{Version:"vX.X.X", GitCommit:"...", GitTreeState:"clean", GoVersion:"goX.X.X"}



brew install terraform
# Terraform is an infrastructure as code tool that allows you to manage cloud resources.

# Test Terraform installation
terraform --version
# Expected output:
# Terraform vX.X.X (version number installed)



brew install ansible
# Ansible is an open-source tool for automating tasks like configuration management and application deployment.

# Test Ansible installation
ansible --version
# Expected output:
# ansible [core X.X.X] (version number installed)



brew install jenkins-lts
# Jenkins is a popular open-source automation server used to build, test, and deploy applications.

# Test Jenkins installation
jenkins-lts --version
# Expected output:
# Jenkins X.X.X (version number installed)


#spinnaker
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/macos/InstallHalyard.sh
sudo bash InstallHalyard.sh
# Spinnaker is an open-source continuous delivery platform for releasing software changes with high velocity and confidence.

# Test Spinnaker Halyard installation
hal --version
# Expected output:
# X.X.X (Halyard version number installed)



brew install --cask postman
# Postman is an API client for testing and developing APIs.

# Test Postman installation
# Postman does not have a CLI, but you can verify it by launching it from Applications or running:
open /Applications/Postman.app
# Expected output:
# Postman GUI opens successfully


brew install prometheus
# Prometheus is an open-source monitoring and alerting toolkit.

# Test Prometheus installation
prometheus --version
# Expected output:
# prometheus, version X.X.X (version number installed)


brew install grafana
# Grafana is an open-source platform for monitoring and observability.

# Test Grafana installation
grafana-server --version
# Expected output:
# Version X.X.X (version number installed)


brew install k9s
# K9s is a terminal-based UI to interact with Kubernetes clusters.

# Test K9s installation
k9s version
# Expected output:
# Version: X.X.X (version number installed)


brew install --cask virtualbox
# VirtualBox is a free and open-source tool for creating and running virtual machines.

# Test VirtualBox installation
vboxmanage --version
# Expected output:
# X.X.X (version number installed)


brew install vagrant
# Vagrant is a tool for building and managing virtualized development environments.

# Test Vagrant installation
vagrant --version
# Expected output:
# Vagrant X.X.X (version number installed)

brew install --cask iterm2
# iTerm2 is a replacement terminal for macOS that offers more features than the default Terminal app.

# Test iTerm2 installation
# iTerm2 doesn’t have a CLI command, but you can open it using:
open /Applications/iTerm.app
# Expected output:
# iTerm2 GUI opens successfully


brew install zsh
# Zsh is a popular shell designed for interactive use, and it can replace Bash as your default shell.

# Test Zsh installation
zsh --version
# Expected output:
# zsh X.X.X (version number installed)


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Oh My Zsh is a framework for managing Zsh configurations and plugins.

# Test Oh My Zsh installation
# Open a new terminal session. You should see the Oh My Zsh theme and prompt. 
# Expected output:
# Oh My Zsh theme and configuration loaded


brew install tmux
# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions inside a single terminal window.

# Test Tmux installation
tmux -V
# Expected output:
# tmux X.X (version number installed)


brew install --cask rectangle
# Rectangle is a window management tool for organizing application windows on macOS.

# Test Rectangle installation
# Rectangle does not have a CLI, but you can launch it from Applications or use a keyboard shortcut to move a window.
open /Applications/Rectangle.app
# Expected output:
# Rectangle GUI opens successfully, or window moves per shortcut


brew install --cask alfred
# Alfred is a productivity application that helps you search and launch apps and perform actions faster.

# Test Alfred installation
# Alfred does not have a CLI, but you can activate it by pressing `Option + Space`.
# Expected output:
# Alfred search bar opens successfully



export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"
export PYTHONPATH="/usr/local/bin/python3"
export SPARK_HOME=$(brew --prefix apache-spark)
export PATH="$SPARK_HOME/bin:$PATH"
export FLINK_HOME=$(brew --prefix apache-flink)
export PATH="$FLINK_HOME/bin:$PATH"



jdk: 21.0.4 2024-07-16 LTS
jre: azulu
maven: 3.9.9
gradle: 8.10.1
Kotlin: 1.9.24
Groovy: 3.0.22
python3: 3.12.6
scala: 3.5.0
docker 27.2.0
kubectl kustomize: v5.4.2
kubectl client: v1.31.1
minikube: v1.34.0
helm: v3.16.1
terraform: v1.5.7
ansible: core 2.17.4
jenkins: 2.462.2
prometheus: 2.54.1
grafana: 11.2.0
k9s: 0.32.5
vboxmanage: 7.1.0
vagrant: 2.4.1
tmux: 3.4


# SPARK: 3.5.3
spark-3.5.3-bin-hadoop3
# 1) Download the spark 3.5 stable tarball
https://www.apache.org/dyn/closer.lua/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz
# 2) Install it and cleanup
mkdir ~/install && cd ~/install
mv ~/Downloads/spark-3.0.1*3.2.tgz .
tar -xvzf spark-3.5.3-bin-hadoop3.tgz
rm -rf spark-3.5.3-bin-hadoop3.tgz
# 3) Update the env path in zshrc path
code ~/.zshrc  
# add the following
export SPARK_HOME=/Users/`whoami`/install/spark-3.5.3-bin-hadoop3
alias spark-shell=”$SPARK_HOME/bin/spark-shell”
# save and close
# run this
source ~/.zshrc 
echo $SPARK_HOME      
/Users/mishra.shubham/install/spark-3.5.3-bin-hadoop3



# -------- SBT ISSUE FIX -----------
# Issue: sbt projects: was not working and throwing error on java
# works only with JAVA 8, 11, 17
# download dmg file from https://www.azul.com/core-post-download/?endpoint=zulu&uuid=d26e939a-e306-430c-b56e-1a879ffa0c2d
# install and check the installation by running --  /usr/libexec/java_home -V               
# would see 2 JVMs: 21 and 17
# update the .zshrc to point to 17:
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"
# delete and reinstall sbt
rm -rf ~/.sbt/boot/
rm -rf ~/.ivy2/cache/
brew reinstall sbt
# make J17 the default JVM for sbt commant by adding this to .zshrc
alias sbt='JAVA_HOME=$(/usr/libexec/java_home -v 17) sbt'
# Configure sbt to use a directory where you have write permissions by setting the 
# SBT_GLOBAL_BASE environment variable to a location in your home directory.
mkdir -p ~/sbt-global-base
# add this .zshrc
export SBT_GLOBAL_BASE=~/sbt-global-base
source ~/.zshrc  # or source ~/.bash_profile
# verify permissions
sudo chown -R $(whoami) ~/.sbt
# WORKS NOW !!
mishra.shubham@mishras-ltmqxvm ~ % sbt -V                        
# [info] [launcher] getting org.scala-sbt sbt 1.10.2  (this may take some time)...
# [info] [launcher] getting Scala 2.12.19 (for sbt)...
# sbt version in this project: 1.10.2
# sbt script version: 1.10.3



#------------------- SFORCE JDK  -------------------#
# download the required version of onejdk from nexus to ~/install/ : https://nexus-dev.data.sfdc.net/nexus/#
# macos | aarch64 | tar.gz
mv 
cd ~/install/
gzip -dc /path/to/download/<variant>-<version>.tar.gz | tar xf -
rm -rf /path/to/download/<variant>-<version>.tar.gz
#Update ~/.zshrc
export JAVA_HOME=/Users/`whoami`/install/openjdk_17.0.12.0.101_17.53.12_aarch64
export PATH="$JAVA_HOME/bin:$PATH"


#------------------ SDKMAN -------------------#
curl -s "https://get.sdkman.io" | bash
source "/Users/mishra.shubham/.sdkman/bin/sdkman-init.sh"
sdk update
sdk list java
sdk install java 11.0.25-zulu

