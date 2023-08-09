sudo dnf install python3 redhat-rpm-config gcc libffi-devel python3-devel openssl-devel cargo pkg-config -y
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install cryptography --no-binary --ignore-installed setuptools_rust cryptography
sudo python3 -m pip install ansible kubernetes jsonpatch PyYAML setuptools --ignore-installed
ansible-galaxy collection install kubernetes.core
ansible-playbook yaml/ansible/deploy.yaml